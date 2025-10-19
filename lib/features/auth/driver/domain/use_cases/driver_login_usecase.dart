import '../repositories/driver_auth_repository.dart';
import '../../../../../../core/error/failures.dart';
import '../entities/driver_entity.dart';
import 'package:dartz/dartz.dart';

class DriverLoginUseCase {
  final DriverAuthRepository repository;
  DriverLoginUseCase(this.repository);

  Future<Either<Failure, DriverEntity>> call(DriverLoginParams params) async {
    return await repository.loginDriver(
        email: params.email, password: params.password);
  }
}

class DriverLoginParams {
  final String email;
  final String password;
  DriverLoginParams({required this.email, required this.password});
}
