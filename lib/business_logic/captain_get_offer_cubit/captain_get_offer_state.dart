part of 'captain_get_offer_cubit.dart';

@immutable
sealed class CaptainGetOfferState {}

final class CaptainGetOfferInitial extends CaptainGetOfferState {}

final class CaptainGetOfferLoading extends CaptainGetOfferState {}

final class CaptainGetOfferSuccess extends CaptainGetOfferState {
  final CaptainGetOfferModel captainGetOfferModel;

  CaptainGetOfferSuccess({required this.captainGetOfferModel});
}

final class CaptainGetOfferFailure extends CaptainGetOfferState {
  final String message;

  CaptainGetOfferFailure({required this.message});
}
