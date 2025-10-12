part of 'captain_cancel_ride_offer_cubit.dart';

@immutable
sealed class CaptainCancelRideOfferState {}

final class CaptainCancelRideOfferInitial extends CaptainCancelRideOfferState {}

final class CaptainCancelRideOfferLoading extends CaptainCancelRideOfferState {}

final class CaptainCancelRideOfferSuccess extends CaptainCancelRideOfferState {
  final CaptainCancelRideOfferModel captainCancelRideOfferModel;

  CaptainCancelRideOfferSuccess({required this.captainCancelRideOfferModel});
}

final class CaptainCancelRideOfferFailure extends CaptainCancelRideOfferState {
  final String message;

  CaptainCancelRideOfferFailure({required this.message});
}
