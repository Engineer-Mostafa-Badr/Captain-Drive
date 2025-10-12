part of 'captain_get_profile_data_cubit.dart';

@immutable
sealed class CaptainGetProfileDataState {}

final class CaptainGetProfileDataInitial extends CaptainGetProfileDataState {}

final class CaptainGetProfileDataLoading extends CaptainGetProfileDataState {}

final class CaptainGetProfileDataSuccess extends CaptainGetProfileDataState {
  final CaptainGetDataModel captainGetDataModel;

  CaptainGetProfileDataSuccess({required this.captainGetDataModel});
}

final class CaptainGetProfileDataFailure extends CaptainGetProfileDataState {
  final String message;

  CaptainGetProfileDataFailure({required this.message});
}
