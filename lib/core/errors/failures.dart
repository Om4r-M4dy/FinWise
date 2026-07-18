import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection. Please check your network."]);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = "An unexpected error occurred."]);
}

Failure mapException(dynamic error) {
  // Log raw exception details in the terminal for debugging (e.g. Firebase Indexing links)
  debugPrint('========================================================================');
  debugPrint('FIREBASE ERROR ENCOUNTERED:');
  debugPrint('$error');
  debugPrint('========================================================================');

  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'user-not-found':
        return const AuthenticationFailure('No user found for that email.');
      case 'wrong-password':
        return const AuthenticationFailure('Wrong password provided.');
      case 'email-already-in-use':
        return const AuthenticationFailure('The account already exists for that email.');
      case 'invalid-email':
        return const AuthenticationFailure('The email address is invalid.');
      case 'weak-password':
        return const AuthenticationFailure('The password is too weak.');
      default:
        return AuthenticationFailure(error.message ?? 'Authentication failed.');
    }
  }
  if (error is FirebaseException) {
    if (error.code == 'unavailable' || error.code == 'network-request-failed') {
      return const NetworkFailure();
    }
    if (error.code == 'permission-denied') {
      return const DatabaseFailure('You do not have permission to access this data.');
    }
    return const DatabaseFailure('A database error occurred. Please try again later.');
  }
  return const UnknownFailure('An unexpected error occurred. Please try again.');
}

Future<bool> hasInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com').timeout(const Duration(seconds: 3));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
