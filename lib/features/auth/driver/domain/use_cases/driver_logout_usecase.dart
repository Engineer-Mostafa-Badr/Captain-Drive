import '../repositories/driver_auth_repository.dart';
import '../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class DriverLogoutUseCase {
  final DriverAuthRepository repository;
  DriverLogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logoutDriver();
  }
}
