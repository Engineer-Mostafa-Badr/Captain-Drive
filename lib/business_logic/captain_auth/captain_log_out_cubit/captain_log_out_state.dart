part of 'captain_log_out_cubit.dart';

@immutable
sealed class CaptainLogOutState {}

final class CaptainLogOutInitial extends CaptainLogOutState {}

final class CaptainLogOutLoading extends CaptainLogOutState {}

final class CaptainLogOutSuccess extends CaptainLogOutState {
  final CaptainLogOutModel captainLogOutModel;

  CaptainLogOutSuccess({required this.captainLogOutModel});
}

final class CaptainLogOutFailure extends CaptainLogOutState {
  final String message;
  CaptainLogOutFailure({required this.message});
}
