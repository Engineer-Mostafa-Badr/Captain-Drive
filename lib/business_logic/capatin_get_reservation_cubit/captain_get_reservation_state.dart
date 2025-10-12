part of 'captain_get_reservation_cubit.dart';

@immutable
sealed class CaptainGetReservationState {}

final class CaptainGetReservationInitial extends CaptainGetReservationState {}

final class CaptainGetReservationLoading extends CaptainGetReservationState {}

final class CaptainGetReservationSuccess extends CaptainGetReservationState {
  final CaptainGetReservationModel captainGetReservationModel;

  CaptainGetReservationSuccess({required this.captainGetReservationModel});
}

final class CaptainGetReservationFailure extends CaptainGetReservationState {
  final String message;

  CaptainGetReservationFailure({required this.message});
}
