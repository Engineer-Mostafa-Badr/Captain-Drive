import '../../domain/use_cases/driver_delete_account_usecase.dart';
import '../../domain/use_cases/driver_sign_up_usecase.dart';
import '../../domain/use_cases/driver_logout_usecase.dart';
import '../../domain/use_cases/driver_login_usecase.dart';
import '../../../../../../core/storage/cache_helper.dart';
import '../../domain/params/driver_sign_up_params.dart';
import '../../domain/entities/driver_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'driver_auth_state.dart';

class DriverAuthCubit extends Cubit<DriverAuthState> {
  final DriverLoginUseCase loginUseCase;
  final DriverSignUpUseCase signUpUseCase;
  final DriverLogoutUseCase logoutUseCase;
  final DriverDeleteAccountUseCase deleteAccountUseCase;

  DriverAuthCubit({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
  }) : super(DriverAuthInitial());

  /// 🔹 تسجيل الدخول
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(DriverAuthLoading());
    final result =
        await loginUseCase(DriverLoginParams(email: email, password: password));

    result.fold(
      (failure) => emit(DriverAuthFailure(failure.message)),
      (driver) async {
        // حفظ التوكن بعد النجاح
        await CacheHelper.saveData(key: 'driver_token', value: driver.token);
        emit(DriverAuthSuccess(driver));
      },
    );
  }

  /// 🔹 إنشاء حساب جديد
  Future<void> signUp(DriverSignUpParams params) async {
    emit(DriverAuthLoading());
    final result = await signUpUseCase(params);

    result.fold(
      (failure) => emit(DriverAuthFailure(failure.message)),
      (driver) async {
        await CacheHelper.saveData(key: 'driver_token', value: driver.token);
        emit(DriverAuthSuccess(driver));
      },
    );
  }

  /// 🔹 تسجيل الخروج
  Future<void> logout() async {
    emit(DriverAuthLoading());
    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(DriverAuthFailure(failure.message)),
      (_) async {
        await CacheHelper.removeData(key: 'driver_token');
        emit(DriverLogoutSuccess());
      },
    );
  }

  /// 🔹 حذف الحساب نهائيًا
  Future<void> deleteAccount() async {
    emit(DriverAuthLoading());
    final result = await deleteAccountUseCase();

    result.fold(
      (failure) => emit(DriverAuthFailure(failure.message)),
      (_) async {
        await CacheHelper.clearAll();
        emit(DriverDeleteAccountSuccess());
      },
    );
  }
}
