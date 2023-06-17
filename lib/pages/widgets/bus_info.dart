import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web_buses/bloc/bus/bus_bloc.dart';
import 'package:web_buses/bloc/stop/stop_bloc.dart';
import 'package:web_buses/models/bus.dart';
import 'package:web_buses/models/stop.dart';

class BusInfo extends StatelessWidget {
  final String busID;
  const BusInfo({
    Key? key,
    required this.busID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusBloc, BusState>(
      builder: (context, state) {
        if (state is BusesLoadedState) {
          Bus bus = getBusById(busID, state.buses);
          String? actualDriver = bus.actualDriver;
          return Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  width: 450,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.shade400,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.directions_bus,
                                      color: Colors.white),
                                  const SizedBox(width: 5),
                                  (bus.line != '99')
                                      ? Text(
                                          "Linea ${bus.line.toUpperCase()} ${bus.company.toUpperCase()}",
                                          style: GoogleFonts.openSans(
                                              textStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)))
                                      : Text("${bus.company.toUpperCase()}",
                                          style: GoogleFonts.openSans(
                                              textStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)))
                                ],
                              ),
                              Text(
                                  "Numero de coche: ${bus.vehiculeNumber.toUpperCase()} ",
                                  style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              // Text("Empresa: ${bus.company.toUpperCase()}",
                              //     style: GoogleFonts.openSans(
                              //         textStyle: const TextStyle(
                              //             fontSize: 15,
                              //             color: Colors.white,
                              //             fontWeight: FontWeight.bold))),
                              // Text(
                              //     "Numero de vehiculo: ${bus.vehiculeNumber.toUpperCase()} ",
                              //     style: GoogleFonts.openSans(
                              //         textStyle: const TextStyle(
                              //             fontSize: 15,
                              //             color: Colors.white,
                              //             fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (actualDriver != null)
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Conductor:  ",
                                              style: GoogleFonts.openSans(
                                                  textStyle: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Text(actualDriver,
                                              style: GoogleFonts.openSans(
                                                  textStyle: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ]))
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Proxima parada:",
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600))),
                                  Text(getStopByID(bus.nextStop, context).title,
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 5),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         "Esperando en prox. parada:",
                            //         style: GoogleFonts.openSans(
                            //             textStyle: TextStyle(
                            //                 color: Colors.black87,
                            //                 fontWeight: FontWeight.w600)),
                            //       ),
                            //       Text(
                            //         "${getStopByID(bus.nextStop, context).waiting}",
                            //         style: GoogleFonts.openSans(
                            //             textStyle: TextStyle(
                            //                 color: Colors.black87,
                            //                 fontWeight: FontWeight.bold)),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 10),
                            //   child: Text("Listado de paradas: ",
                            //       style: GoogleFonts.openSans(
                            //           textStyle: TextStyle(
                            //               color: Colors.black87,
                            //               fontWeight: FontWeight.w600))),
                            // ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: busStops(bus, context),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // GestureDetector(
                //   onTap: () {
                //     setOnLocationHistoryPage(true);
                //   },
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                //     decoration: BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //           color:
                //               Colors.deepPurpleAccent.shade400.withOpacity(0.2),
                //           spreadRadius: 5,
                //           blurRadius: 7,
                //           offset: Offset(0, 3), // changes position of shadow
                //         ),
                //       ],
                //       color: Colors.deepPurpleAccent.shade400,
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.history,
                //           color: Colors.white,
                //           size: 20,
                //         ),
                //         SizedBox(
                //           width: 10,
                //         ),
                //         Text("Historial de ubicaciones",
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w600))
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

//   busStops(Bus bus, BuildContext ctx) {
//     int n = 0;
//     List<Widget> paradas = bus.stops.map((stopID) {
//       n++;
//       return Container(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//           child: Row(
//             children: [
//               Text(
//                 "$n -  ",
//                 style: GoogleFonts.openSans(
//                     textStyle: TextStyle(
//                         color: Colors.black87, fontWeight: FontWeight.bold)),
//               ),
//               Text(
//                 "${getStopByID(stopID, ctx).title}",
//                 style: GoogleFonts.openSans(
//                     textStyle: TextStyle(
//                         color: Colors.black87, fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ));
//     }).toList();
//     return paradas;
//   }

  Bus getBusById(String busID, List<Bus> buses) {
    Bus busReturn = buses[buses.indexWhere((element) => busID == element.id)];
    return busReturn;
  }

  Stop getStopByID(nextStop, BuildContext ctx) {
    var state =
        Provider.of<StopBloc>(ctx, listen: false).state as StopsLoadedState;
    return state.stops.firstWhere((element) => element.id == nextStop);
  }
}
