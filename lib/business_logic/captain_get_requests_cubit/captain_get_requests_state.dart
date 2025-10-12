part of 'captain_get_requests_cubit.dart';

@immutable
sealed class CaptainGetRequestsState {}

final class CaptainGetRequestsInitial extends CaptainGetRequestsState {}

final class CaptainGetRequestsLoading extends CaptainGetRequestsState {}

final class CaptainGetRequestsSuccess extends CaptainGetRequestsState {
  final CaptainGetRequestModel captainGetRequestModel;
  CaptainGetRequestsSuccess({required this.captainGetRequestModel});
}

final class CaptainGetRequestsFailure extends CaptainGetRequestsState {
  final String message;
  CaptainGetRequestsFailure({required this.message});
}
