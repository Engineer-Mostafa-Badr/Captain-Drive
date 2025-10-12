part of 'captain_cancel_reservation_offer_cubit.dart';

@immutable
sealed class CaptainCancelReservationOfferState {}

final class CaptainCancelReservationOfferInitial
    extends CaptainCancelReservationOfferState {}

final class CaptainCancelReservationOfferLoading
    extends CaptainCancelReservationOfferState {}

final class CaptainCancelReservationOfferSuccess
    extends CaptainCancelReservationOfferState {
  final CaptainCancelReservationOfferModel captainCancelReservationOfferModel;

  CaptainCancelReservationOfferSuccess(
      {required this.captainCancelReservationOfferModel});
}

final class CaptainCancelReservationOfferFailure
    extends CaptainCancelReservationOfferState {
  final String message;

  CaptainCancelReservationOfferFailure({required this.message});
}
