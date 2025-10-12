part of 'captain_activities_cubit.dart';

@immutable
sealed class CaptainActivitiesState {}

final class CaptainActivitiesInitial extends CaptainActivitiesState {}

final class CaptainActivitiesLoading extends CaptainActivitiesState {}

final class CaptainActivitiesSuccess extends CaptainActivitiesState {
  final GetCaptainActivitiesModel getCaptainActivitiesModel;

  CaptainActivitiesSuccess({required this.getCaptainActivitiesModel});
}

final class CaptainActivitiesFailure extends CaptainActivitiesState {
  final String message;

  CaptainActivitiesFailure({required this.message});
}
