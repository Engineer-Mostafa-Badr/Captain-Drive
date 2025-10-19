// passenger_delete_account_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/passenger_auth_repository.dart';

class PassengerDeleteAccountUseCase {
  final PassengerAuthRepository repository;

  PassengerDeleteAccountUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAccount();
  }
}
