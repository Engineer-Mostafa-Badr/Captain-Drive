part of 'arrive_reservation_cubit.dart';

@immutable
sealed class ArriveReservationState {}

final class ArriveReservationInitial extends ArriveReservationState {}

final class ArriveReservationLoading extends ArriveReservationState {}

final class ArriveReservationSuccess extends ArriveReservationState {
  final ArriveReservation arriveReservation;

  ArriveReservationSuccess({required this.arriveReservation});
}

final class ArriveReservationFailure extends ArriveReservationState {
  final String message;

  ArriveReservationFailure({required this.message});
}
