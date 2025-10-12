part of 'sign_in_captain_cubit.dart';

@immutable
sealed class SignInCaptainState {}

final class SignInCaptainInitial extends SignInCaptainState {}

final class SignInCaptainLoading extends SignInCaptainState {}

final class SignInCaptainSuccess extends SignInCaptainState {
  final CaptainLoginModel captainLoginModel;

  SignInCaptainSuccess({required this.captainLoginModel});
}

final class SignInCaptainFailure extends SignInCaptainState {
  final String message;

  SignInCaptainFailure(this.message);
}
