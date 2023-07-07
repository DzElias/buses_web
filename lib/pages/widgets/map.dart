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
import 'package:web_buses/utils/cachedTileProvider.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3o4c3Nla20xbnBrMnBwMTN4cXpuOGYxIn0.wfniiVLrGVbimAqr_OKyMg';
// ignore: constant_identifier_names
const MAPBOX_STYLE = 'mapbox/light-v10';
// ignore: constant_identifier_names
const MARKER_COLOR = Colors.blueAccent;

List<AssetImage> images = [
  const AssetImage("assets/bus-point-green.png"),
  const AssetImage(
    "assets/bus-point-yellow.png",
  ),
  const AssetImage("assets/bus-point-blue-accent.png"),
  const AssetImage("assets/bus-point-brown.png"),
  const AssetImage("assets/bus-point-red.png"),
  const AssetImage("assets/bus-point-purple.png"),
  const AssetImage("assets/bus-point-greenAccent.png"),
  const AssetImage("assets/bus-point-blue.png"),
  const AssetImage("assets/bus-point-orange.png"),
  const AssetImage("assets/bus-point-blueGray.png"),
];

class MapWidget extends StatefulWidget {
  MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // ignore: avoid_init_to_null
  Stop? stopSelected = null;
  String busSelected = "";
  @override
  Widget build(BuildContext context) {
    MapOptions mapOptions = MapOptions(
        center: const LatLng(-25.5161428, -54.6418963),
        zoom: 14,
        minZoom: 6,
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate);

    List<Marker> buildMarkers(List stops) {
      if (stops.isEmpty) {
        return [];
      }
      List<Marker> markerList = [];

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
                    await Future.delayed(const Duration(seconds: 5))
                        .then((value) => setState(() {
                              if (stopSelected == stopSel) {
                                stopSelected = null;
                              }
                            }));
                  },
                  child: const BusStopMarker());
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
                      await Future.delayed(const Duration(seconds: 5))
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
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(stopSelected!.title,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SimpleAttributionWidget(
                        source: Text('OpenStreetMap contributors'),
                      ),
                    ],
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.web_buses',
                        tileProvider: CachedTileProvider(),
                      ),
                      PolylineLayer(
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
                      MarkerLayer(markers: buildMarkers(stopstate.stops)),
                      MarkerLayer(markers: getActiveBuses(bustate.buses)),
                    ],
                  ),
                  (busSelected.isNotEmpty)
                      ? BusInfo(
                          busID: busSelected,
                        )
                      : const SizedBox(),
                  const ColorsBox()
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
