import 'dart:developer';
import 'package:captain_drive/screens/captain/chat/errors/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to create a new user with email, password, name, and profile image
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? profileImageUrl, // Optional profile image
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = credential.user!;

      // Save user details to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'email': email,
        'name': name,
        'createdAt': DateTime.now(),
        'profileImageUrl': profileImageUrl ?? '', // Optional profile image
      });

      return user;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException in createUserWithEmailAndPassword: $e, code: ${e.code}');

      switch (e.code) {
        case 'weak-password':
          throw CustomException(message: 'The password is too weak.');
        case 'email-already-in-use':
          throw CustomException(
              message: 'This email is already registered. Please log in.');
        case 'network-request-failed':
          throw CustomException(
              message: 'Please check your internet connection.');
        default:
          throw CustomException(
              message: 'An unknown error occurred. Please try again.');
      }
    } catch (e) {
      log('Exception in createUserWithEmailAndPassword: $e');
      throw CustomException(
          message: 'An unknown error occurred. Please try again.');
    }
  }

  // Method to sign in a user with email and password
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException in signInWithEmailAndPassword: $e, code: ${e.code}');

      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          throw CustomException(message: 'Incorrect email or password.');
        case 'network-request-failed':
          throw CustomException(
              message: 'Please check your internet connection.');
        default:
          throw CustomException(
              message: 'An unknown error occurred. Please try again.');
      }
    } catch (e) {
      log('Exception in signInWithEmailAndPassword: $e');
      throw CustomException(
          message: 'An unknown error occurred. Please try again.');
    }
  }
}
