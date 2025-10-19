// passenger_logout_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/passenger_auth_repository.dart';

class PassengerLogoutUseCase {
  final PassengerAuthRepository repository;

  PassengerLogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
