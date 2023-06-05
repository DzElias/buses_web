part of 'stop_bloc.dart';

abstract class StopEvent extends Equatable {
  const StopEvent();

  @override
  List<Object> get props => [];
}

class SaveStopsEvent extends StopEvent {
  final dynamic payload;

  const SaveStopsEvent(this.payload);
}
