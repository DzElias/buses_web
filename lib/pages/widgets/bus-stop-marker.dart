import 'package:flutter/material.dart';

class BusStopMarker extends StatelessWidget {
  const BusStopMarker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const size = 60.0;
    return Center(
        child: AnimatedContainer(
            height: size,
            width: size,
            duration: const Duration(milliseconds: 300),
            child: const Image(image: AssetImage('assets/busStop.png'))));
  }
}
