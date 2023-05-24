import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:web_buses/bloc/buses/buses_bloc.dart';
import 'package:web_buses/bloc/stops/stops_bloc.dart';
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
    final stopsBloc = Provider.of<StopsBloc>(context, listen: false);
    final busesBloc = Provider.of<BusesBloc>(context, listen: false);
    final socket = Provider.of<SocketService>(context, listen: false).socket;
    socket.connect();
    socket.on("loadStops", stopsBloc.loadStops);
    socket.on("loadBuses", busesBloc.loadBuses);

    await Future.delayed(const Duration(seconds: 2));

    FlutterNativeSplash.remove();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(),
        ],
      ),
    );
  }
}
