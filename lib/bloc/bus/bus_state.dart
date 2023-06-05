part of 'bus_bloc.dart';

abstract class BusState extends Equatable {
  const BusState();
  
  @override
  List<Object> get props => [];
}

class BusesLoadingState extends BusState {}

class BusesLoadedState extends BusState {
  final List<Bus> buses;

  const BusesLoadedState(this.buses);
}
