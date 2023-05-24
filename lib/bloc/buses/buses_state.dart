part of 'buses_bloc.dart';

@immutable
class BusesState {
  final List<Bus> buses;

  const BusesState({
    this.buses = const [],
  });

  BusesState copyWith({
    List<Bus>? buses,
  }) =>
      BusesState(
        buses: buses ?? this.buses,
      );

}
