part of 'set_arrive_ride_cubit.dart';

@immutable
sealed class SetArriveRideState {}

final class SetArriveRideInitial extends SetArriveRideState {}

final class SetArriveRideLoading extends SetArriveRideState {}

final class SetArriveRideSuccess extends SetArriveRideState {
  final SetArriveRideModel setArriveRideModel;

  SetArriveRideSuccess({required this.setArriveRideModel});
}

final class SetArriveRideFailure extends SetArriveRideState {
  final String message;

  SetArriveRideFailure({required this.message});
}
