import '../../features/auth/driver/data/data_sources/driver_auth_remote_data_source.dart';
import '../../features/auth/driver/domain/use_cases/driver_delete_account_usecase.dart';
import '../../features/auth/driver/data/repositories/driver_auth_repository_impl.dart';
import '../../features/auth/driver/domain/repositories/driver_auth_repository.dart';
import '../../features/auth/driver/domain/use_cases/driver_sign_up_usecase.dart';
import '../../features/auth/driver/domain/use_cases/driver_logout_usecase.dart';
import '../../features/auth/driver/domain/use_cases/driver_login_usecase.dart';
import '../../features/auth/driver/presentation/cubit/driver_auth_cubit.dart';

import '../../features/auth/passenger/data/data_sources/passenger_auth_remote_data_source.dart';
import '../../features/auth/passenger/data/repositories/passenger_auth_repository_impl.dart';
import '../../features/auth/passenger/domain/repositories/passenger_auth_repository.dart';
import '../../features/auth/passenger/domain/use_cases/passenger_login_usecase.dart';
import '../../features/auth/passenger/domain/use_cases/passenger_signup_usecase.dart';
import '../../features/auth/passenger/domain/use_cases/passenger_logout_usecase.dart';
import '../../features/auth/passenger/domain/use_cases/passenger_delete_account_usecase.dart';
import '../../features/auth/passenger/presentation/cubit/passenger_auth_cubit.dart';

import '../network/dio_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // =========================
  // 🔹 Core
  // =========================
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioHelper>(() => DioHelper());

  // =========================
  // 🔹 DRIVER AUTH SECTION
  // =========================

  // Data Source
  sl.registerLazySingleton<DriverAuthRemoteDataSource>(
    () => DriverAuthRemoteDataSourceImpl(dioHelper: sl()),
  );

  // Repository
  sl.registerLazySingleton<DriverAuthRepository>(
    () => DriverAuthRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => DriverLoginUseCase(sl()));
  sl.registerLazySingleton(() => DriverSignUpUseCase(sl()));
  sl.registerLazySingleton(() => DriverLogoutUseCase(sl()));
  sl.registerLazySingleton(() => DriverDeleteAccountUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => DriverAuthCubit(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
      deleteAccountUseCase: sl(),
    ),
  );

  // =========================
  // 🔹 PASSENGER AUTH SECTION
  // =========================

  // Data Source
  sl.registerLazySingleton<PassengerAuthRemoteDataSource>(
    () => PassengerAuthRemoteDataSourceImpl(dioHelper: sl()),
  );

  // Repository
  sl.registerLazySingleton<PassengerAuthRepository>(
    () => PassengerAuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => PassengerLoginUseCase(sl()));
  sl.registerLazySingleton(() => PassengerSignUpUseCase(sl()));
  sl.registerLazySingleton(() => PassengerLogoutUseCase(sl()));
  sl.registerLazySingleton(() => PassengerDeleteAccountUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => PassengerAuthCubit(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
      deleteAccountUseCase: sl(),
    ),
  );
}
