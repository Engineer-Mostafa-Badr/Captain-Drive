part of 'driver_set_current_location_cubit.dart';

@immutable
sealed class DriverSetCurrentLocationState {}

final class DriverSetCurrentLocationInitial
    extends DriverSetCurrentLocationState {}

final class DriverSetCurrentLocationLoading
    extends DriverSetCurrentLocationState {}

final class DriverSetCurrentLocationSuccess
    extends DriverSetCurrentLocationState {
  final DriverSetCurrentLocationModel setCurrentLocationModel;

  DriverSetCurrentLocationSuccess({required this.setCurrentLocationModel});
}

final class DriverSetCurrentLocationFailure
    extends DriverSetCurrentLocationState {
  final String message;

  DriverSetCurrentLocationFailure({required this.message});
}
