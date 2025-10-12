part of 'camera_model_cubit.dart';

@immutable
sealed class CameraModelState {}

final class CameraModelInitial extends CameraModelState {}

final class CameraModelLoading extends CameraModelState {}

final class CameraModelSuccess extends CameraModelState {
  final CameraModel cameraModel;

  CameraModelSuccess({required this.cameraModel});
}

final class CameraModelFailure extends CameraModelState {
  final String message;

  CameraModelFailure({required this.message});
}
