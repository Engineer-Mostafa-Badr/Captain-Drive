import 'package:bloc/bloc.dart';
import 'package:captain_drive/screens/captain/chat/domain/entities/user_entity.dart';
import 'package:captain_drive/screens/captain/chat/domain/repos/auth_repo.dart';
import 'package:meta/meta.dart';

import '../../models/message_model.dart';

part 'firebase_sign_in_state.dart';

class FirebaseSignInCubit extends Cubit<FirebaseSignInState> {
  FirebaseSignInCubit(this.authRepo) : super(FirebaseSignInInitial());

  final AuthRepo authRepo;
  MessageModel? messageModel;

  Future<void> signInWithEmailAndPassword(
      String? email, String password) async {
    emit(FirebaseSignInLoading());
    final result = await authRepo.signInWithEmailAndPassword(
      email!,
      password,
    );
    result.fold(
      (failure) => emit(FirebaseSignInFailure(message: failure.message)),
      (userEntity) => emit(FirebaseSignInSuccess(
        userEntity: userEntity,
      )),
    );
  }
}
