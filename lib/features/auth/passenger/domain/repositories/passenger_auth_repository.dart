// domain/repositories/passenger_auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../entities/passenger_entity.dart';
import '../params/passenger_signup_params.dart';

abstract class PassengerAuthRepository {
  Future<Either<Failure, PassengerEntity>> login(String email, String password);
  Future<Either<Failure, PassengerEntity>> signUp(PassengerSignUpParams params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> deleteAccount();
}
