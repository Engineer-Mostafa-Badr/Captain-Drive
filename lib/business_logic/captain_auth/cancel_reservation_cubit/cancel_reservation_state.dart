part of 'cancel_reservation_cubit.dart';

@immutable
sealed class CancelReservationState {}

final class CancelReservationInitial extends CancelReservationState {}

final class CancelReservationLoading extends CancelReservationState {}

final class CancelReservationSuccess extends CancelReservationState {
  final CancelReservation cancelReservation;

  CancelReservationSuccess({required this.cancelReservation});
}

final class CancelReservationFailure extends CancelReservationState {
  final String message;

  CancelReservationFailure({required this.message});
}
