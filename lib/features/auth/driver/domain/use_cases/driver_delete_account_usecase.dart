import '../repositories/driver_auth_repository.dart';
import '../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class DriverDeleteAccountUseCase {
  final DriverAuthRepository repository;
  DriverDeleteAccountUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteDriverAccount();
  }
}
