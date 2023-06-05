import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_buses/bloc/bus/bus_bloc.dart';
import 'package:web_buses/models/bus.dart';

// List<AssetImage> images = [
//   AssetImage("assets/bus-point-yellow",),
//   AssetImage("assets/bus-point-accent"),
//   AssetImage("assets/bus-point-brown"),
//   AssetImage("assets/bus-point-green"),
//   AssetImage("assets/bus-point-red")
// ];
List<Color> colors = [
  Colors.green,
  Colors.yellow,
  Colors.blueAccent,
  Colors.brown,
  Colors.red,
  Colors.purple,
  Colors.greenAccent,
  Colors.blue,
  Colors.orange,
  Colors.blueGrey,
];

class ColorsBox extends StatelessWidget {
  const ColorsBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusBloc, BusState>(
      builder: (context, state) {
        if (state is BusesLoadedState) {
          List<Bus> buses = state.buses;
          List<Widget> children = [];

          if (buses.isNotEmpty) {
            int cont = 0;
            String lineaActual = buses[0].line;
            int i = 0;
            children = buses.map((bus) {
              if (cont > 0 && bus.line == lineaActual) {
                return SizedBox();
              }
              if (bus.line != lineaActual) {
                lineaActual = bus.line;
                i++;
              }

              if (i > 0) {}
              cont++;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, color: colors[i], size: 20),
                    SizedBox(
                      width: 10,
                    ),
                    (bus.line != "99")
                        ? Text(
                            "LINEA ${bus.line.toUpperCase()}   -  ${bus.company.toUpperCase()}",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )
                        : Text(
                            "${bus.company.toUpperCase()}",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )
                  ],
                ),
              );
            }).toList();
          }
          return Positioned(
            top: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.shade400,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Text("LINEAS DISPONIBLES",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (children.isNotEmpty)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children)
                      : Center(
                          child: Text(
                              "Actualmente ningun bus se encuentra activo :("),
                        )
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
