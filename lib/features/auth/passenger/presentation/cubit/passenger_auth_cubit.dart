// passenger_auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/passenger_entity.dart';
import '../../domain/params/passenger_signup_params.dart';
import '../../domain/use_cases/passenger_delete_account_usecase.dart';
import '../../domain/use_cases/passenger_login_usecase.dart';
import '../../domain/use_cases/passenger_logout_usecase.dart';
import '../../domain/use_cases/passenger_signup_usecase.dart';
part 'passenger_auth_state.dart';

class PassengerAuthCubit extends Cubit<PassengerAuthState> {
  final PassengerLoginUseCase loginUseCase;
  final PassengerSignUpUseCase signUpUseCase;
  final PassengerLogoutUseCase logoutUseCase;
  final PassengerDeleteAccountUseCase deleteAccountUseCase;

  PassengerAuthCubit({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
  }) : super(PassengerAuthFailure('Initial state'));

  Future<void> login(String email, String password) async {
    emit(PassengerLogInLoading());
    final result = await loginUseCase(email: email, password: password);
    result.fold(
      (failure) => emit(PassengerLogInFailure(failure.message)),
      (user) => emit(PassengerLogInSuccess(user)),
    );
  }

  Future<void> signUp(PassengerSignUpParams params) async {
    emit(PassengerAuthLoading());
    final result = await signUpUseCase(params);
    result.fold(
      (failure) => emit(PassengerAuthFailure(failure.message)),
      (user) => emit(PassengerAuthSuccess(user)),
    );
  }

  Future<void> logout() async {
    emit(PassengerLogOutLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(PassengerLogOutFailure(failure.message)),
      (_) => emit(PassengerLogOutSuccess()),
    );
  }

  Future<void> deleteAccount() async {
    emit(PassengerAccountDeleteLoading());
    final result = await deleteAccountUseCase();
    result.fold(
      (failure) => emit(PassengerAccountDeleteFailure(failure.message)),
      (_) => emit(PassengerAccountDeletedSuccess()),
    );
  }
}
