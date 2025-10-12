part of 'captain_change_password_cubit.dart';

@immutable
sealed class CaptainChangePasswordState {}

final class CaptainChangePasswordInitial extends CaptainChangePasswordState {}

final class CaptainChangePasswordLoading extends CaptainChangePasswordState {}

final class CaptainChangePasswordSuccess extends CaptainChangePasswordState {
  final CaptainChangePasswordModel captainChangePasswordModel;

  CaptainChangePasswordSuccess({required this.captainChangePasswordModel});
}

final class CaptainChangePasswordFailure extends CaptainChangePasswordState {
  final String message;

  CaptainChangePasswordFailure({required this.message});
}
