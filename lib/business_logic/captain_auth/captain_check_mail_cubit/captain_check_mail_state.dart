part of 'captain_check_mail_cubit.dart';

@immutable
sealed class CaptainCheckMailState {}

final class CaptainCheckMailInitial extends CaptainCheckMailState {}

final class CaptainCheckMailLoading extends CaptainCheckMailState {}

final class CaptainCheckMailSuccess extends CaptainCheckMailState {
  final CaptainCheckMailModel captainCheckMailModel;

  CaptainCheckMailSuccess({required this.captainCheckMailModel});
}

final class CaptainCheckMailFailure extends CaptainCheckMailState {
  final String message;

  CaptainCheckMailFailure({required this.message});
}
