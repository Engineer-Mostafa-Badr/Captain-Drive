import 'dart:developer';
import 'package:captain_drive/screens/captain/chat/domain/entities/user_entity.dart';
import 'package:captain_drive/screens/captain/chat/domain/repos/auth_repo.dart';
import 'package:captain_drive/screens/captain/chat/errors/exceptions.dart';
import 'package:captain_drive/screens/captain/chat/errors/failures.dart';
import 'package:captain_drive/screens/captain/chat/services/firebase_auth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_mode.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final FirebaseFirestore firestore;

  AuthRepoImpl({
    required this.firebaseAuthService,
    required this.firestore,
  });

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String name,
    String email,
    String password, {
    String? profileImageUrl, // Optional profile image URL
  }) async {
    try {
      // Create user using FirebaseAuth
      User user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      preferences.get('fcmToken');

      // Save user details to Firestore
      await firestore.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImageUrl': profileImageUrl ?? '',
        'fcmToken': preferences.get('fcmToken').toString(),
      });

      // Return UserEntity
      return right(UserModel(
        uId: user.uid,
        email: user.email!,
        name: name,
        profileImageUrl: profileImageUrl ?? '',
        createdAt: DateTime.now(),
        fcmToken: preferences.get('fcmToken').toString(),
      ));
    } on CustomException catch (e) {
      log('CustomException in createUserWithEmailAndPassword: ${e.message}');
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in createUserWithEmailAndPassword: $e');
      return left(
          ServerFailure('An unknown error occurred. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Sign in user using FirebaseAuth
      User user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch additional user details from Firestore
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;

        // Return UserEntity with data from Firestore
        return right(UserModel(
          uId: user.uid,
          email: user.email!,
          name: userData['name'] ?? '',
          profileImageUrl:
              userData['profileImageUrl'] ?? 'assets/images/image.png',
          createdAt:
              (userData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          fcmToken: userData['fcmToken'],
        ));
      } else {
        return left(ServerFailure('User data not found in Firestore.'));
      }
    } on CustomException catch (e) {
      log('CustomException in signInWithEmailAndPassword: ${e.message}');
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in signInWithEmailAndPassword: $e');
      return left(
          ServerFailure('An unknown error occurred. Please try again.'));
    }
  }
}
