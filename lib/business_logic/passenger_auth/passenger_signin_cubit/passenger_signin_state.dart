part of 'passenger_signin_cubit.dart';

@immutable
sealed class PassengerSigninState {}

final class PassengerSigninInitial extends PassengerSigninState {}

final class PassengerSigninLoading extends PassengerSigninState {}

final class PassengerSigninSuccess extends PassengerSigninState {
  late final LoginModel passengerLoginModel;
  PassengerSigninSuccess(this.passengerLoginModel);
}

final class PassengerSigninFailure extends PassengerSigninState {
  final String message;

  PassengerSigninFailure({required this.message});
}
