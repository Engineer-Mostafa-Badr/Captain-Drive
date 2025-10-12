part of 'captain_create_new_password_cubit.dart';

@immutable
sealed class CaptainCreateNewPasswordState {}

final class CaptainCreateNewPasswordInitial
    extends CaptainCreateNewPasswordState {}

final class CaptainCreateNewPasswordLoading
    extends CaptainCreateNewPasswordState {}

final class CaptainCreateNewPasswordSuccess
    extends CaptainCreateNewPasswordState {
  final CaptainCreateNewPasswordModel captainCreateNewPasswordModel;

  CaptainCreateNewPasswordSuccess(
      {required this.captainCreateNewPasswordModel});
}

final class CaptainCreateNewPasswordFailure
    extends CaptainCreateNewPasswordState {
  final String message;

  CaptainCreateNewPasswordFailure({required this.message});
}
