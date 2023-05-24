import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:web_buses/bloc/buses/buses_bloc.dart';
import 'package:web_buses/bloc/stops/stops_bloc.dart';
import 'package:web_buses/routes.dart';
import 'package:web_buses/services/socket_service.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    windowData = windowData.copyWith(
        textScaleFactor: windowData.textScaleFactor > 1.0
            ? 1.0
            : windowData.textScaleFactor);
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => StopsBloc()),
        BlocProvider(create: (_) => BusesBloc()),
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: Builder(builder: (context) {
        return MediaQuery(
          data: windowData,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Buses CDE',
            initialRoute: '/',
            routes: appRoutes,
          ),
        );
      }),
    );
  }
}
