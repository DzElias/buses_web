part of 'bus_bloc.dart';

abstract class BusEvent extends Equatable {
  const BusEvent();

  @override
  List<Object> get props => [];
}

class SaveBusesEvent extends BusEvent {
  final dynamic payload;

  const SaveBusesEvent(this.payload);
}
