import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:finwise/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordVerfiyController = TextEditingController();
  final nameController = TextEditingController();
  // Helper method to fetch user data from Firestore or create it if not exists
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
        dob: 0.0,
        monthlyBudgetLimit: 0.0,
        settings: {'pushNotifications': true, 'darkTheme': false},
      );
      await FirestoreProvider.addUser(userModel);
      return userModel;
    }
  }

  Future<void> loginWithEmailAndPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      emit(AuthFailure('Please enter both email and password.'));
      return;
    }

    emit(AuthLoading());

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = userCredential.user;
      if (user != null) {
        final userModel = await _getOrCreateUserModel(user);

        // Save name to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', userModel.username ?? '');

        emit(AuthSuccess(userModel: userModel));
      } else {
        emit(AuthFailure('Login failed: User is null'));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    emit(AuthLoading());
    try {
      final userCredential = await GoogleAuth.signInWithGoogle(context);
      if (userCredential != null && userCredential.user != null) {
        final userModel = await _getOrCreateUserModel(userCredential.user!);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', userModel.username ?? '');

        emit(AuthSuccess(userModel: userModel));
      } else {
        emit(AuthFailure('Google sign-in was cancelled or failed.'));
      }
    } catch (e) {
      emit(AuthFailure('Google sign-in error: $e'));
    }
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    emit(AuthLoading());
    try {
      final userCredential = await FacebookAuthService.signInWithFacebook(context);
      if (userCredential != null && userCredential.user != null) {
        final userModel = await _getOrCreateUserModel(userCredential.user!);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', userModel.username ?? '');

        emit(AuthSuccess(userModel: userModel));
      } else {
        emit(AuthFailure('Facebook sign-in was cancelled or failed.'));
      }
    } catch (e) {
      emit(AuthFailure('Facebook sign-in error: $e'));
    }
  }
}
