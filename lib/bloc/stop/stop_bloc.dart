import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_buses/models/stop.dart';

part 'stop_event.dart';
part 'stop_state.dart';

class StopBloc extends Bloc<StopEvent, StopState> {
  StopBloc() : super(StopsLoadingState()) {
    on<SaveStopsEvent>((event, emit) {
      List<Stop> stops = [];
      for (var map in event.payload) {
        stops.add(Stop.fromMap(map));
      }
      emit(StopsLoadedState(stops));
    });
  }
}
