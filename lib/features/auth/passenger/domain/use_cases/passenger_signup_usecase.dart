// passenger_signup_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/passenger_entity.dart';
import '../params/passenger_signup_params.dart';
import '../repositories/passenger_auth_repository.dart';

class PassengerSignUpUseCase {
  final PassengerAuthRepository repository;

  PassengerSignUpUseCase(this.repository);

  Future<Either<Failure, PassengerEntity>> call(
      PassengerSignUpParams params) async {
    return await repository.signUp(params);
  }
}
