part of 'captain_get_message_cubit.dart';

@immutable
sealed class CaptainGetMessageState {}

final class CaptainGetMessageInitial extends CaptainGetMessageState {}

final class CaptainGetMessageLoading extends CaptainGetMessageState {}

final class CaptainGetMessageSuccess extends CaptainGetMessageState {
  final CaptainGetMessageModel captainGetMessageModel;

  CaptainGetMessageSuccess({required this.captainGetMessageModel});
}

final class CaptainGetMessageFailure extends CaptainGetMessageState {
  final String message;

  CaptainGetMessageFailure({required this.message});
}
