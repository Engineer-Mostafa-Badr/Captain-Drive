import 'package:captain_drive/screens/captain/chat/domain/entities/user_entity.dart';
import 'package:captain_drive/core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// Abstract repository interface for authentication operations.
abstract class AuthRepo {
  /// Creates a new user with the provided [name], [email], and [password].
  /// Optionally, a [profileImageUrl] can be provided.
  ///
  /// Returns a [Either] with a [Failure] on the left and a [UserEntity] on the right.
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String name,
    String email,
    String password, {
    String? profileImageUrl, // Optional profile image URL
  });

  /// Returns a [Either] with a [Failure] on the left and a [UserEntity] on the right.
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
}
