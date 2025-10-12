part of 'captain_forget_password_cubit.dart';

@immutable
sealed class CaptainForgetPasswordState {}

final class CaptainForgetPasswordInitial extends CaptainForgetPasswordState {}

final class CaptainForgetPasswordLoading extends CaptainForgetPasswordState {}

final class CaptainForgetPasswordSuccess extends CaptainForgetPasswordState {
  final CaptainForgetPasswordModel captainForgetPasswordModel;

  CaptainForgetPasswordSuccess({required this.captainForgetPasswordModel});
}

final class CaptainForgetPasswordFailure extends CaptainForgetPasswordState {
  final String message;

  CaptainForgetPasswordFailure({required this.message});
}
