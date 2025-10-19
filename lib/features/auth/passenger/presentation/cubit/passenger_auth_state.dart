part of 'passenger_auth_cubit.dart';

abstract class PassengerAuthState {}

class PassengerLogInLoading extends PassengerAuthState {}

class PassengerLogInSuccess extends PassengerAuthState {
  final PassengerEntity user;
  PassengerLogInSuccess(this.user);
}

class PassengerLogInFailure extends PassengerAuthState {
  final String message;
  PassengerLogInFailure(this.message);
}

class PassengerAuthLoading extends PassengerAuthState {}

class PassengerAuthSuccess extends PassengerAuthState {
  final PassengerEntity user;
  PassengerAuthSuccess(this.user);
}

class PassengerAuthFailure extends PassengerAuthState {
  final String message;
  PassengerAuthFailure(this.message);
}

class PassengerLogOutLoading extends PassengerAuthState {}

class PassengerLogOutSuccess extends PassengerAuthState {}

class PassengerLogOutFailure extends PassengerAuthState {
  final String message;
  PassengerLogOutFailure(this.message);
}

class PassengerAccountDeleteLoading extends PassengerAuthState {}

class PassengerAccountDeletedSuccess extends PassengerAuthState {}

class PassengerAccountDeleteFailure extends PassengerAuthState {
  final String message;
  PassengerAccountDeleteFailure(this.message);
}
