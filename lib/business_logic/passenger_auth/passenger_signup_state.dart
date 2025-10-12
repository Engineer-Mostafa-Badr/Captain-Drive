part of 'passenger_signup_cubit.dart';

@immutable
sealed class PassengerSignUpState {}

final class PassengerSignUpInitial extends PassengerSignUpState {}

final class PassengerSignUpLoading extends PassengerSignUpState {}

final class PassengerSignUpSuccess extends PassengerSignUpState {
  late final RegisterModel passengerRegisterModel;
  PassengerSignUpSuccess(this.passengerRegisterModel);
}

final class PassengerSignUpFailure extends PassengerSignUpState {
  final String message;

  PassengerSignUpFailure({required this.message});
}

final class PassengerSignUpWithGoogleInitial extends PassengerSignUpState {}

final class PassengerSignUpWithGoogleLoading extends PassengerSignUpState {}

final class PassengerSignUpWithGoogleSuccess extends PassengerSignUpState {
  // late final RegisterGoogleModel passengerRegisterGoogleModel;
  // PassengerSignUpWithGoogleSuccess(this.passengerRegisterGoogleModel);
}

final class PassengerSignUpWithGoogleFailure extends PassengerSignUpState {
  final String message;

  PassengerSignUpWithGoogleFailure({required this.message});
}

final class PassengerSignUpWithFacebookInitial extends PassengerSignUpState {}

final class PassengerSignUpWithFacebookLoading extends PassengerSignUpState {}

final class PassengerSignUpWithFacebookSuccess extends PassengerSignUpState {
  // late final RegisterFacebookModel passengerRegisterFacebookModel;
  // PassengerSignUpWithFacebookSuccess(this.passengerRegisterFacebookModel);
}

final class PassengerSignUpWithFacebookFailure extends PassengerSignUpState {
  final String message;

  PassengerSignUpWithFacebookFailure({required this.message});
}
