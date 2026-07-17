import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/profile/data/models/user_model.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:finwise/core/functions/facebook_auth.dart';

class AuthRepo {
  Future<UserModel> _getOrCreateUserModel(User user) async {
    final doc = await FirestoreProvider.user.doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      final userModel = UserModel(
        uid: user.uid,
        username: user.displayName ?? '',
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        profilePicture: user.photoURL ?? '',
        totalBalance: 0.0,
        totalExpense: 0.0,
        totalIncome: 0.0,
        dob: 0.0,
        monthlyBudgetLimit: 0.0,
        settings: {'pushNotifications': true, 'darkTheme': false},
      );
      await FirestoreProvider.addUser(userModel);
      return userModel;
    }
  }

  Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        final userModel = await _getOrCreateUserModel(user);
        return Right(userModel);
      } else {
        return const Left(UnknownFailure('Login failed: User is null'));
      }
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, UserModel>> loginWithGoogle(
    BuildContext context,
  ) async {
    try {
      final userCredential = await GoogleAuth.signInWithGoogle(context);
      if (userCredential != null && userCredential.user != null) {
        final userModel = await _getOrCreateUserModel(userCredential.user!);
        return Right(userModel);
      } else {
        return const Left(
          UnknownFailure('Google sign-in was cancelled or failed.'),
        );
      }
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, UserModel>> loginWithFacebook(
    BuildContext context,
  ) async {
    try {
      final userCredential = await FacebookAuthService.signInWithFacebook(
        context,
      );
      if (userCredential != null && userCredential.user != null) {
        final userModel = await _getOrCreateUserModel(userCredential.user!);
        return Right(userModel);
      } else {
        return const Left(
          UnknownFailure('Facebook sign-in was cancelled or failed.'),
        );
      }
    } catch (e) {
      return Left(mapException(e));
    }
  }
}
