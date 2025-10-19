// passenger_login_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/passenger_entity.dart';
import '../repositories/passenger_auth_repository.dart';

class PassengerLoginUseCase {
  final PassengerAuthRepository repository;

  PassengerLoginUseCase(this.repository);

  Future<Either<Failure, PassengerEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email, password);
  }
}
