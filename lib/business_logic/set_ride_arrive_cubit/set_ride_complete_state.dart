part of 'set_ride_complete_cubit.dart';

@immutable
sealed class SetRideCompleteState {}

final class SetRideCompleteInitial extends SetRideCompleteState {}

final class SetRideCompleteLoading extends SetRideCompleteState {}

final class SetRideCompleteSuccess extends SetRideCompleteState {
  final SetRideCompleteModel setRideCompleteModel;

  SetRideCompleteSuccess({required this.setRideCompleteModel});
}

final class SetRideCompleteFailure extends SetRideCompleteState {
  final String message;
  SetRideCompleteFailure({required this.message});
}
