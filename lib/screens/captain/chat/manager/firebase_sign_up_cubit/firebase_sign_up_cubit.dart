import 'package:bloc/bloc.dart';
import 'package:captain_drive/screens/captain/chat/domain/entities/user_entity.dart';
import 'package:captain_drive/screens/captain/chat/domain/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'firebase_sign_up_state.dart';

class FirebaseSignUpCubit extends Cubit<FirebaseSignUpState> {
  FirebaseSignUpCubit(this.authRepo) : super(FirebaseSignUpInitial());

  final AuthRepo authRepo;

  Future<void> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    emit(FirebaseSignUpLoading());
    final result = await authRepo.createUserWithEmailAndPassword(
      name,
      email,
      password,
    );
    result.fold(
      (failure) => emit(FirebaseSignUpFailure(message: failure.message)),
      (userEntity) => emit(FirebaseSignUpSuccess(userEntity: userEntity)),
    );
  }
}
