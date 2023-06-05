import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:polyline_codec/polyline_codec.dart';
import 'package:web_buses/bloc/bus/bus_bloc.dart';
import 'package:web_buses/bloc/stop/stop_bloc.dart';
import 'package:web_buses/models/bus.dart';
import 'package:web_buses/models/stop.dart';
import 'package:web_buses/pages/widgets/bus-stop-marker.dart';
import 'package:web_buses/pages/widgets/bus_info.dart';
import 'package:web_buses/pages/widgets/colors_box.dart';
import 'package:web_buses/utils/busRoutes.dart';
import 'package:web_buses/utils/cachedTileProvider.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3o4c3Nla20xbnBrMnBwMTN4cXpuOGYxIn0.wfniiVLrGVbimAqr_OKyMg';
const MAPBOX_STYLE = 'mapbox/light-v10';
const MARKER_COLOR = Colors.blueAccent;

List<AssetImage> images = [
  AssetImage("assets/bus-point-green.png"),
  AssetImage(
    "assets/bus-point-yellow.png",
  ),
  AssetImage("assets/bus-point-blue-accent.png"),
  AssetImage("assets/bus-point-brown.png"),
  AssetImage("assets/bus-point-red.png"),
  AssetImage("assets/bus-point-purple.png"),
  AssetImage("assets/bus-point-greenAccent.png"),
  AssetImage("assets/bus-point-blue.png"),
  AssetImage("assets/bus-point-orange.png"),
  AssetImage("assets/bus-point-blueGray.png"),
];

class MapWidget extends StatefulWidget {
  MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Stop? stopSelected = null;
  String busSelected = "";
  @override
  Widget build(BuildContext context) {
    MapOptions mapOptions = MapOptions(
        center: LatLng(-25.5161428, -54.6418963),
        zoom: 14,
        minZoom: 6,
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate);

    List<Marker> buildMarkers(List stops) {
      if (stops.isEmpty) {
        return [];
      }
      List<Marker> markerList = [];
      bool istapped = false;

      for (int i = 0; i < stops.length; i++) {
        Stop stop = stops[i];

        markerList.add(Marker(
            height: 50,
            width: 50,
            point: LatLng(stop.latitude, stop.longitude),
            builder: (_) {
              return GestureDetector(
                  onTap: () async {
                    setState(() {
                      stopSelected = stop;
                    });

                    var stopSel = stopSelected;
                    await Future.delayed(Duration(seconds: 5))
                        .then((value) => setState(() {
                              if (stopSelected == stopSel) {
                                stopSelected = null;
                              }
                            }));
                  },
                  child: BusStopMarker());
            }));
      }

      return markerList;
    }

    List<Marker> getActiveBuses(List<Bus> buses) {
      List<Marker> markerList = [];
      if (buses.isNotEmpty) {
        buses.sort((a, b) => int.parse(a.line).compareTo(int.parse(b.line)));
        String lineaActual = buses[0].line;
        int i = 0;

        for (var bus in buses) {
          if (bus.line != lineaActual) {
            lineaActual = bus.line;
            i++;
          }
          var color = images[i];
          markerList.add(Marker(
              width: 60,
              height: 60,
              point: LatLng(bus.latitude, bus.longitude),
              key: Key(bus.id),
              builder: (_) => GestureDetector(
                    onTap: () async {
                      setState(() {
                        busSelected = bus.id;
                      });

                      var busSel = busSelected;
                      await Future.delayed(Duration(seconds: 5))
                          .then((value) => setState(() {
                                if (busSelected == busSel) {
                                  busSelected = "";
                                }
                              }));
                    },
                    child: Center(
                        child: Image(
                      image: color,
                    )),
                  )));
        }
      }
      return markerList;
    }

    int i = 0;
    String busCompany = "";

    return BlocBuilder<BusBloc, BusState>(
      builder: (context, bustate) {
        return BlocBuilder<StopBloc, StopState>(
          builder: (context, stopstate) {
            if (bustate is BusesLoadedState && stopstate is StopsLoadedState) {
              return Stack(
                children: [
                  FlutterMap(
                    options: mapOptions,
                    nonRotatedChildren: [
                      stopSelected != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  height: 40,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurpleAccent.shade400,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(stopSelected!.title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                          additionalOptions: {
                            'accessToken': MAPBOX_ACCESS_TOKEN,
                            'id': MAPBOX_STYLE
                          },
                          tileProvider: const CachedTileProvider()),
                      PolylineLayerOptions(
                          polylines: bustate.buses.map((bus) {
                        if (busCompany == "") {
                          busCompany = bus.company;
                        }
                        if (bus.company != busCompany) {
                          i++;
                        }
                        busCompany = bus.company;
                        return Polyline(
                            strokeWidth: 6,
                            color: colors[i],
                            points: PolylineCodec.decode(bus.ruta)
                                .map((e) =>
                                    LatLng(e[0].toDouble(), e[1].toDouble()))
                                .toList());
                      }).toList()),
                      MarkerLayerOptions(
                          markers: buildMarkers(stopstate.stops)),
                      MarkerLayerOptions(
                          markers: getActiveBuses(bustate.buses)),
                    ],
                  ),
                  (busSelected.isNotEmpty)
                      ? BusInfo(
                          busID: busSelected,
                        )
                      : const SizedBox(),
                  ColorsBox()
                ],
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
