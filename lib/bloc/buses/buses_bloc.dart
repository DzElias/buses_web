import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/Material.dart';
import 'package:web_buses/models/bus.dart';

part 'buses_event.dart';
part 'buses_state.dart';

class BusesBloc extends Bloc<BusesEvent, BusesState> {
  BusesBloc() : super(BusesState()) {
    on<OnBusesFoundEvent>(
        (event, emit) => emit(state.copyWith(buses: event.buses)));
  }

  Future loadBuses(var response) async {
    List<Bus> buses = [];

    for (var bus in response) {
      buses.add(Bus.fromMap(bus));
    }
    add(OnBusesFoundEvent(buses));
  }
}
