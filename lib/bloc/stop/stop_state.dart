part of 'stop_bloc.dart';

class StopState extends Equatable {
  const StopState();
  
  @override
  List<Object> get props => [];
}

class StopsLoadingState extends StopState {}

class StopsLoadedState extends StopState {
  final List<Stop> stops;

  const StopsLoadedState(this.stops);

}

