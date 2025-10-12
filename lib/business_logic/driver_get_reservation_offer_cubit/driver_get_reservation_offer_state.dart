part of 'driver_get_reservation_offer_cubit.dart';

@immutable
sealed class DriverGetReservationOfferState {}

final class DriverGetReservationOfferInitial
    extends DriverGetReservationOfferState {}

final class DriverGetReservationOfferLoading
    extends DriverGetReservationOfferState {}

final class DriverGetReservationOfferSuccess
    extends DriverGetReservationOfferState {
  final DriverGetOfferModel driverGetReservationModel;

  DriverGetReservationOfferSuccess({required this.driverGetReservationModel});
}

final class DriverGetReservationOfferFailure
    extends DriverGetReservationOfferState {
  final String message;

  DriverGetReservationOfferFailure({required this.message});
}
