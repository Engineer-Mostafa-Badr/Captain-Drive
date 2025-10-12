part of 'captain_cancel_offer_cubit.dart';

@immutable
sealed class CaptainCancelOfferState {}

final class CaptainCancelOfferInitial extends CaptainCancelOfferState {}

final class CaptainCancelOfferLoading extends CaptainCancelOfferState {}

final class CaptainCancelOfferSuccess extends CaptainCancelOfferState {
  final CaptainCancelOfferModel cancelOfferModel;
  CaptainCancelOfferSuccess({required this.cancelOfferModel});
}

final class CaptainCancelOfferFailure extends CaptainCancelOfferState {
  final String message;
  CaptainCancelOfferFailure({required this.message});
}
