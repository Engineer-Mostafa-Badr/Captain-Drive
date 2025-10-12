part of 'driver_status_cubit.dart';

@immutable
sealed class DriverStatusState {}

final class DriverStatusInitial extends DriverStatusState {}

final class DriverStatusLoading extends DriverStatusState {}

final class DriverStatusSuccess extends DriverStatusState {
  final DriverStatusModel driverStatusModel;

  DriverStatusSuccess({required this.driverStatusModel});
}

final class DriverStatusFailure extends DriverStatusState {
  final String message;

  DriverStatusFailure({required this.message});
}
