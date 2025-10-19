// data/repositories/passenger_auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../../domain/entities/passenger_entity.dart';
import '../../domain/params/passenger_signup_params.dart';
import '../../domain/repositories/passenger_auth_repository.dart';
import '../data_sources/passenger_auth_remote_data_source.dart';

class PassengerAuthRepositoryImpl implements PassengerAuthRepository {
  final PassengerAuthRemoteDataSource remoteDataSource;

  PassengerAuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PassengerEntity>> login(
      String email, String password) async {
    try {
      final result = await remoteDataSource.loginPassenger(email, password);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    }
  }

  @override
  Future<Either<Failure, PassengerEntity>> signUp(
      PassengerSignUpParams params) async {
    try {
      final result = await remoteDataSource.signUpPassenger({
        'name': params.name,
        'email': params.email,
        'phone': params.phone,
        'password': params.password,
        'password_confirmation': params.confirmPassword,
      });
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logoutPassenger();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deletePassengerAccount();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    }
  }
}
