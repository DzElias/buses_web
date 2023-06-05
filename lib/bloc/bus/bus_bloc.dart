import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_buses/models/bus.dart';

part 'bus_event.dart';
part 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  BusBloc() : super(BusesLoadingState()) {
    on<SaveBusesEvent>((event, emit) {
      List<Bus> buses = [];
      for (var map in event.payload) {
        Bus bus = Bus.fromMap(map);
        if (bus.isActive) {
          buses.add(Bus.fromMap(map));
        }
      }
      emit(BusesLoadingState());
      emit(BusesLoadedState(buses));
    });
  }
}
