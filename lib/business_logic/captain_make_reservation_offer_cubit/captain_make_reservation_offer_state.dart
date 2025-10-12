part of 'captain_make_reservation_offer_cubit.dart';

@immutable
sealed class CaptainMakeReservationOfferState {}

final class CaptainMakeReservationOfferInitial
    extends CaptainMakeReservationOfferState {}

final class CaptainMakeReservationOfferLoading
    extends CaptainMakeReservationOfferState {}

final class CaptainMakeReservationOfferSuccess
    extends CaptainMakeReservationOfferState {
  final CaptainMakeReservationOfferModel captainMakeReservationOfferModel;

  CaptainMakeReservationOfferSuccess(
      {required this.captainMakeReservationOfferModel});
}

final class CaptainMakeReservationOfferFailure
    extends CaptainMakeReservationOfferState {
  final String message;

  CaptainMakeReservationOfferFailure({required this.message});
}
