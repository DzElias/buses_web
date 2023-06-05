import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:web_buses/bloc/bus/bus_bloc.dart';
import 'package:web_buses/bloc/stop/stop_bloc.dart';
import 'package:web_buses/pages/widgets/map.dart';
import 'package:web_buses/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      initialization();
    });
    super.initState();
  }

  void initialization() async {
    final stopsBloc = Provider.of<StopBloc>(context, listen: false);
    final busesBloc = Provider.of<BusBloc>(context, listen: false);
    final socket = Provider.of<SocketService>(context, listen: false).socket;
    socket.connect();
    socket.on("loadStops", (data) => stopsBloc.add(SaveStopsEvent(data)));
    socket.on("loadBuses", (data) => busesBloc.add(SaveBusesEvent(data)));

    await Future.delayed(const Duration(seconds: 2));
  }

  Widget build(BuildContext context) {
    return BlocBuilder<BusBloc, BusState>(
      builder: (context, busstate) {
        return BlocBuilder<StopBloc, StopState>(
          builder: (context, stopstate) {
            if (stopstate is StopsLoadedState && busstate is BusesLoadedState) {
              Future.delayed(Duration.zero)
                  .then((value) => FlutterNativeSplash.remove());
              return Scaffold(
                body: Stack(
                  children: [
                    MapWidget(),
                  ],
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
