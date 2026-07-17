import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/persentation/widgets/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/core/services/notification/notification_service.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || password.length < 6) {
      setState(() => _errorText = "Password must be at least 6 characters");
      return;
    }
    if (password != confirmPassword) {
      setState(() => _errorText = "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(password);
        
        final notificationData = {
          'title': 'Security Update',
          'subTitle': 'Your password has been changed successfully.',
          'iconPath': 'assets/icons/Security.svg',
          'date': DateTime.now(),
          'isRead': false,
        };
        await FirestoreProvider.addNotification(user.uid, notificationData);

        // Show instant system notification
        await NotificationService.showInstantNotification(
          title: 'Security Update',
          body: 'Your password has been changed successfully.',
        );

        if (mounted) {
          replaceWith(context, Routes.passwordChangedScreen);
        }
      } else {
        setState(() => _errorText = "No user logged in.");
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          if (e.code == 'requires-recent-login') {
            _errorText = "Please log out and log back in to change password.";
          } else if (e.code == 'weak-password') {
            _errorText = "The password provided is too weak.";
          } else {
            _errorText = e.message ?? "An error occurred.";
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorText = "Failed to update password.");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              const Gap(30),
              SafeArea(
                bottom: false,
                child: Text(
                  "New password",
                  style: TextStyles.size_30.copyWith(
                    color: AppColors.lettersAndIcons,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(30),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(50),
                        Text(
                          "New Password",
                          style: TextStyles.caption1_14.copyWith(
                            color: AppColors.lettersAndIcons,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(8),
                        AuthTextField(
                          hintText: "Password",
                          isPassword: true,
                          controller: _passwordController,
                        ),
                        const Gap(30),
                        Text(
                          "Confirm New Password",
                          style: TextStyles.caption1_14.copyWith(
                            color: AppColors.lettersAndIcons,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(8),
                        AuthTextField(
                          hintText: "Password",
                          isPassword: true,
                          controller: _confirmPasswordController,
                        ),
                        if (_errorText != null) ...[
                          const Gap(16),
                          Text(
                            _errorText!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                        const Gap(60),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Change Password",
                              style: TextStyles.headline_24.copyWith(
                                fontSize: 20,
                                color: AppColors.lettersAndIcons,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        LoadingOverlay(
          isLoading: _isLoading,
          message: "Updating password...",
        ),
      ],
    );
  }
}
