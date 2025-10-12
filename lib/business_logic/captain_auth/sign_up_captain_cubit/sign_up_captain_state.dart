part of 'sign_up_captain_cubit.dart';

@immutable
sealed class SignUpCaptainState {}

final class SignUpCaptainInitial extends SignUpCaptainState {}

final class SignUpCaptainLoading extends SignUpCaptainState {}

final class SignUpCaptainSuccess extends SignUpCaptainState {
  final CaptainSignUpModel signUpCaptainModel;

  SignUpCaptainSuccess({required this.signUpCaptainModel});
}

final class SignUpCaptainFailure extends SignUpCaptainState {
  final String message;

  SignUpCaptainFailure({required this.message});
}
