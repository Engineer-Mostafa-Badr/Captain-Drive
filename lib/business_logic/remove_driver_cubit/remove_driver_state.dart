part of 'remove_driver_cubit.dart';

@immutable
sealed class RemoveDriverState {}

final class RemoveDriverInitial extends RemoveDriverState {}

final class RemoveDriverLoading extends RemoveDriverState {}

final class RemoveDriverSuccess extends RemoveDriverState {
  final RemoveDriverModel removeDriverModel;

  RemoveDriverSuccess({required this.removeDriverModel});
}

final class RemoveDriverFailure extends RemoveDriverState {
  final String message;

  RemoveDriverFailure({required this.message});
}
