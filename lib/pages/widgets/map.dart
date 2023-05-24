import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:web_buses/bloc/buses/buses_bloc.dart';
import 'package:web_buses/bloc/stops/stops_bloc.dart';
import 'package:web_buses/models/bus.dart';
import 'package:web_buses/models/stop.dart';
import 'package:web_buses/pages/widgets/bus-stop-marker.dart';
import 'package:web_buses/pages/widgets/bus_info.dart';
import 'package:web_buses/utils/cachedTileProvider.dart';
import 'package:polyline_do/polyline_do.dart' as poly_do;

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3o4c3Nla20xbnBrMnBwMTN4cXpuOGYxIn0.wfniiVLrGVbimAqr_OKyMg';
const MAPBOX_STYLE = 'mapbox/light-v10';
const MARKER_COLOR = Colors.blueAccent;

List<AssetImage> images = [
  AssetImage(
    "assets/bus-point-yellow.png",
  ),
  AssetImage("assets/bus-point-blue-accent.png"),
  AssetImage("assets/bus-point-brown.png"),
  AssetImage("assets/bus-point-green.png"),
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
  List<List<double>> points = [
    [-54.610150000000004, -25.533620000000003],
    [-54.61110000000001, -25.524770000000004],
    [-54.615660000000005, -25.51546],
    [-54.615190000000005, -25.512100000000004],
    [-54.61515000000001, -25.509510000000002],
    [-54.6182, -25.509520000000002],
    [-54.624590000000005, -25.510880000000004],
    [-54.628640000000004, -25.509950000000003],
    [-54.656690000000005, -25.501030000000004],
    [-54.66044, -25.499760000000002],
    [-54.66046000000001, -25.499380000000002],
    [-54.661010000000005, -25.499180000000003],
    [-54.663320000000006, -25.498230000000003],
    [-54.662240000000004, -25.49576],
    [-54.661590000000004, -25.49331],
    [-54.66304, -25.491190000000003],
    [-54.663500000000006, -25.489860000000004],
    [-54.66310000000001, -25.48854],
    [-54.66113000000001, -25.485850000000003],
    [-54.659890000000004, -25.484140000000004],
    [-54.65755000000001, -25.48094],
    [-54.65276000000001, -25.476830000000003],
    [-54.648920000000004, -25.473950000000002],
    [-54.644850000000005, -25.47089],
    [-54.64153, -25.46843],
    [-54.63902, -25.466540000000002],
    [-54.63613, -25.46554],
    [-54.63570000000001, -25.46555],
    [-54.63729000000001, -25.465460000000004],
    [-54.639050000000005, -25.466350000000002],
    [-54.641600000000004, -25.46824],
    [-54.641670000000005, -25.468290000000003],
    [-54.641670000000005, -25.468290000000003],
    [-54.644890000000004, -25.4707],
    [-54.648950000000006, -25.473730000000003],
    [-54.652820000000006, -25.47661],
    [-54.65769, -25.480800000000002],
    [-54.65999000000001, -25.483970000000003],
    [-54.66120000000001, -25.485660000000003],
    [-54.66322, -25.488360000000004],
    [-54.66358, -25.490560000000002],
    [-54.661770000000004, -25.493430000000004],
    [-54.662400000000005, -25.495630000000002],
    [-54.66351, -25.49828],
    [-54.665130000000005, -25.49789],
    [-54.66586, -25.497870000000002],
    [-54.629000000000005, -25.51019],
    [-54.6246, -25.511020000000002],
    [-54.61985000000001, -25.50993],
    [-54.61549, -25.51404],
    [-54.61576, -25.51566],
    [-54.61124, -25.524810000000002],
    [-54.610150000000004, -25.533640000000002]
  ];
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

      for (int i = 0; i < stops.length; i++) {
        Stop stop = stops[i];

        markerList.add(Marker(
            height: 50,
            width: 50,
            point: LatLng(stop.latitude, stop.longitude),
            builder: (_) {
              return GestureDetector(onTap: () {}, child: BusStopMarker());
            }));
      }

      return markerList;
    }

    String busSelected = "";
    bool sw = false;

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
          var color = images[3];
          markerList.add(Marker(
              width: 60,
              height: 60,
              point: LatLng(bus.latitude, bus.longitude),
              key: Key(bus.id),
              builder: (_) => GestureDetector(
                    onTap: () {
                      setState(() {
                        if (busSelected != bus.id) {
                          busSelected = bus.id;
                        } else {
                          busSelected = "";
                        }
                      });
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

    return BlocBuilder<BusesBloc, BusesState>(
      builder: (context, bustate) {
        return BlocBuilder<StopsBloc, StopsState>(
          builder: (context, stopstate) {
            return Stack(
              children: [
                FlutterMap(
                  options: mapOptions,
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                        additionalOptions: {
                          'accessToken': MAPBOX_ACCESS_TOKEN,
                          'id': MAPBOX_STYLE
                        },
                        tileProvider: const CachedTileProvider()),
                    PolylineLayerOptions(polylines: [
                      Polyline(
                          strokeWidth: 3.0,
                          color: Colors.green,
                          points: points
                              .map((point) => LatLng(point[1], point[0]))
                              .toList())
                    ]),
                    MarkerLayerOptions(markers: buildMarkers(stopstate.stops)),
                    MarkerLayerOptions(markers: getActiveBuses(bustate.buses))
                  ],
                ),
                (busSelected.isNotEmpty)
                    ? BusInfo(
                        busID: busSelected,
                      )
                    : const SizedBox(),
              ],
            );
          },
        );
      },
    );
  }
}
