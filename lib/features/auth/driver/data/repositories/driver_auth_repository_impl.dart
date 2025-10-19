import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/params/driver_sign_up_params.dart';
import '../../domain/repositories/driver_auth_repository.dart';
import '../data_sources/driver_auth_remote_data_source.dart';

class DriverAuthRepositoryImpl implements DriverAuthRepository {
  final DriverAuthRemoteDataSource remoteDataSource;

  DriverAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DriverEntity>> loginDriver({
    required String email,
    required String password,
  }) async {
    try {
      final driver = await remoteDataSource.loginDriver(email, password);
      return Right(driver);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DriverEntity>> signUpDriver(
      DriverSignUpParams params) async {
    try {
      final driver = await remoteDataSource.signUpDriver(params);
      return Right(driver);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logoutDriver() async {
    try {
      await remoteDataSource.logoutDriver();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDriverAccount() async {
    try {
      await remoteDataSource.deleteDriverAccount();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
