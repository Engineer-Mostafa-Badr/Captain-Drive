part of 'captain_get_active_ride_cubit.dart';

@immutable
sealed class CaptainGetActiveRideState {}

final class CaptainGetActiveRideInitial extends CaptainGetActiveRideState {}

final class CaptainGetActiveRideLoading extends CaptainGetActiveRideState {}

final class CaptainGetActiveRideSuccess extends CaptainGetActiveRideState {
  final CaptainGetRideModel captainGetRideModel;

  CaptainGetActiveRideSuccess({required this.captainGetRideModel});
}

final class CaptainGetActiveRideFailure extends CaptainGetActiveRideState {
  final String message;

  CaptainGetActiveRideFailure({required this.message});
}
