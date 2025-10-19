import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../entities/driver_entity.dart';
import '../params/driver_sign_up_params.dart';

abstract class DriverAuthRepository {
  Future<Either<Failure, DriverEntity>> loginDriver({
    required String email,
    required String password,
  });

  Future<Either<Failure, DriverEntity>> signUpDriver(DriverSignUpParams params);

  Future<Either<Failure, void>> logoutDriver();

  Future<Either<Failure, void>> deleteDriverAccount();
}
