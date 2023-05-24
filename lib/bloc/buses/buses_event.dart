part of 'buses_bloc.dart';

abstract class BusesEvent extends Equatable {
  const BusesEvent();

  @override
  List<Object> get props => [];
}

class OnBusesFoundEvent extends BusesEvent {
  final List<Bus> buses;
  const OnBusesFoundEvent(this.buses);
}

class OnBusUpdateEvent extends BusesEvent {
  final String id;
  final double lat;
  final double long;

  const OnBusUpdateEvent(this.id, this.lat, this.long);
}
