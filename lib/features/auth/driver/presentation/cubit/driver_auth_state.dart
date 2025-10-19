part of 'driver_auth_cubit.dart';

abstract class DriverAuthState {}

class DriverAuthInitial extends DriverAuthState {}

class DriverAuthLoading extends DriverAuthState {}

class DriverAuthSuccess extends DriverAuthState {
  final DriverEntity driver;

  DriverAuthSuccess(this.driver);
}

class DriverAuthFailure extends DriverAuthState {
  final String message;

  DriverAuthFailure(this.message);
}

class DriverLogoutSuccess extends DriverAuthState {}

class DriverDeleteAccountSuccess extends DriverAuthState {}
