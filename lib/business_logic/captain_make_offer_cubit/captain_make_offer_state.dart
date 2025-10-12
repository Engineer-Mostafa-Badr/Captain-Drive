part of 'captain_make_offer_cubit.dart';

@immutable
sealed class CaptainMakeOfferState {}

final class CaptainMakeOfferInitial extends CaptainMakeOfferState {}

final class CaptainMakeOfferLoading extends CaptainMakeOfferState {}

final class CaptainMakeOfferSuccess extends CaptainMakeOfferState {
  final CaptainMakeOfferModel captainMakeOfferModel;
  CaptainMakeOfferSuccess({required this.captainMakeOfferModel});
}

final class CaptainMakeOfferFailure extends CaptainMakeOfferState {
  final String message;
  CaptainMakeOfferFailure({required this.message});
}
