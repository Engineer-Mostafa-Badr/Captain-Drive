part of 'captain_get_driver_reservation_cubit.dart';

@immutable
sealed class CaptainGetDriverReservationState {}

final class CaptainGetDriverReservationInitial
    extends CaptainGetDriverReservationState {}

final class CaptainGetDriverReservationLoading
    extends CaptainGetDriverReservationState {}

final class CaptainGetDriverReservationSuccess
    extends CaptainGetDriverReservationState {
  final CaptainGetDriverReservationModel captainGetDriverReservation;
  CaptainGetDriverReservationSuccess(
      {required this.captainGetDriverReservation});
}

final class CaptainGetDriverReservationFailure
    extends CaptainGetDriverReservationState {
  final String message;
  CaptainGetDriverReservationFailure({required this.message});
}
