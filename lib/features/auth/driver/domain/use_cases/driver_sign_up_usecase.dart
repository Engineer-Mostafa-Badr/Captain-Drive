import '../repositories/driver_auth_repository.dart';
import '../../../../../../core/error/failures.dart';
import '../params/driver_sign_up_params.dart';
import '../entities/driver_entity.dart';
import 'package:dartz/dartz.dart';

class DriverSignUpUseCase {
  final DriverAuthRepository repository;

  DriverSignUpUseCase(this.repository);

  Future<Either<Failure, DriverEntity>> call(DriverSignUpParams params) async {
    return await repository.signUpDriver(params);
  }
}
