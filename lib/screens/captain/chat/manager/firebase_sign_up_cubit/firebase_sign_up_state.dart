part of 'firebase_sign_up_cubit.dart';

@immutable
sealed class FirebaseSignUpState {}

final class FirebaseSignUpInitial extends FirebaseSignUpState {}

final class FirebaseSignUpLoading extends FirebaseSignUpState {}

final class FirebaseSignUpSuccess extends FirebaseSignUpState {
  final UserEntity userEntity;

  FirebaseSignUpSuccess({required this.userEntity});
}

final class FirebaseSignUpFailure extends FirebaseSignUpState {
  final String message;

  FirebaseSignUpFailure({required this.message});
}
