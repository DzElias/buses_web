import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_buses/models/stop.dart';

part 'stops_event.dart';
part 'stops_state.dart';

class StopsBloc extends Bloc<StopsEvent, StopsState> {
  StopsBloc() : super(StopsState()) {
    on<OnStopsFoundEvent>(
        (event, emit) => emit(state.copyWith(stops: event.stops)));
  }

  Future loadStops(var response) async {
    List<Stop> stops = [];
    for (var map in response) {
      stops.add(Stop.fromMap(map));
    }

    add(OnStopsFoundEvent(stops));
  }
}
