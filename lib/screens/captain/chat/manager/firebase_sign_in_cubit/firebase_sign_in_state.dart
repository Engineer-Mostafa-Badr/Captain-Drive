part of 'firebase_sign_in_cubit.dart';

@immutable
sealed class FirebaseSignInState {}

final class FirebaseSignInInitial extends FirebaseSignInState {}

final class FirebaseSignInLoading extends FirebaseSignInState {}

final class FirebaseSignInSuccess extends FirebaseSignInState {
  final UserEntity userEntity;

  FirebaseSignInSuccess({required this.userEntity});
}

final class FirebaseSignInFailure extends FirebaseSignInState {
  final String message;

  FirebaseSignInFailure({required this.message});
}
