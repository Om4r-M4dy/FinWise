import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/core/services/notification/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:flutter/material.dart';
import 'package:finwise/features/auth/data/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final _repository = AuthRepo();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordVerfiyController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> loginWithEmailAndPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      emit(AuthFailure('Please enter both email and password.'));
      return;
    }

    emit(AuthLoading());

    final result = await _repository.loginWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    await result.fold(
      (failure) async {
        emit(AuthFailure(failure.message));
      },
      (userModel) async {
        // Save name and login state using UserPrefs
        await UserPrefs.setName(userModel.username ?? '');
        await UserPrefs.setIsLoggedIn(true);

        // Send welcome notification
        final notifyData = {
          'title': 'Welcome Back!',
          'subTitle': 'You have logged in successfully.',
          'iconPath': 'assets/icons/notification.svg',
          'date': DateTime.now(),
          'isRead': false,
        };
        await FirestoreProvider.addNotification(userModel.uid!, notifyData);
        final showPush = userModel.settings?['pushNotifications'] ?? true;
        if (showPush) {
          await NotificationService.showInstantNotification(
            title: 'Welcome Back!',
            body: 'You have logged in successfully.',
          );
        }

        emit(AuthSuccess(userModel: userModel));
      },
    );
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    emit(AuthLoading());
    final result = await _repository.loginWithGoogle(context);

    await result.fold(
      (failure) async {
        emit(AuthFailure(failure.message));
      },
      (userModel) async {
        await UserPrefs.setName(userModel.username ?? '');
        await UserPrefs.setIsLoggedIn(true);

        final notifyData = {
          'title': 'Welcome!',
          'subTitle': 'Logged in with Google successfully.',
          'iconPath': 'assets/icons/Google.svg',
          'date': DateTime.now(),
          'isRead': false,
        };
        await FirestoreProvider.addNotification(userModel.uid!, notifyData);
        final showPush = userModel.settings?['pushNotifications'] ?? true;
        if (showPush) {
          await NotificationService.showInstantNotification(
            title: 'Welcome!',
            body: 'Logged in with Google successfully.',
          );
        }

        emit(AuthSuccess(userModel: userModel));
      },
    );
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    emit(AuthLoading());
    final result = await _repository.loginWithFacebook(context);

    await result.fold(
      (failure) async {
        emit(AuthFailure(failure.message));
      },
      (userModel) async {
        await UserPrefs.setName(userModel.username ?? '');
        await UserPrefs.setIsLoggedIn(true);

        final notifyData = {
          'title': 'Welcome!',
          'subTitle': 'Logged in with Facebook successfully.',
          'iconPath': 'assets/icons/Facebook.svg',
          'date': DateTime.now(),
          'isRead': false,
        };
        await FirestoreProvider.addNotification(userModel.uid!, notifyData);
        final showPush = userModel.settings?['pushNotifications'] ?? true;
        if (showPush) {
          await NotificationService.showInstantNotification(
            title: 'Welcome!',
            body: 'Logged in with Facebook successfully.',
          );
        }

        emit(AuthSuccess(userModel: userModel));
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    passwordVerfiyController.dispose();
    nameController.dispose();
    return super.close();
  }
}
