import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/features/auth/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/widgets/auth_layout.dart';
import 'package:finwise/features/auth/widgets/custom_auth_button.dart';
import 'package:finwise/features/auth/widgets/socialbutton.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/functions/google_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
          ),
        );
        // Continue to pin screen or back to login
        replaceWith(context, Routes.securitypinScreen);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is badly formatted.';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: "Forgot Password",
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(27),
            Text(
              "Reset Password?",
              style: TextStyles.headline_24.copyWith(
                fontSize: 20,
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyles.caption1_14.copyWith(
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            const Gap(40),
            Text(
              "Enter Email Address",
              style: TextStyles.caption1_14.copyWith(
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            AuthTextField(
              hintText: "example@example.com",
              controller: _emailController,
            ),
            const Gap(40),

            /// Next Step Button
            CustomAuthButton(
              text: "Next Step",
              onPressed: _resetPassword,
              isLoading: _isLoading,
            ),

            const Gap(20),

            /// Sign Up Button
            CustomAuthButton(
              text: "Sign Up",
              onPressed: () {
                replaceWith(context, Routes.signupScreen);
              },
              backgroundColor: AppColors.lightGreen,
            ),

            const Gap(28),
            const Center(
              child: Text("or sign up with", style: TextStyle(fontSize: 12)),
            ),
            const Gap(19),

            //google && facebook
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialButton(
                  icon: AppAssets.facebook,
                  onTap: () async {
                    final user = await FacebookAuthService.signInWithFacebook(context);
                    if (user != null && context.mounted) {
                      replaceWith(context, Routes.bottomNavBar);
                    }
                  },
                ),
                const Gap(16),
                SocialButton(
                  icon: AppAssets.google,
                  onTap: () async {
                    final user = await GoogleAuth.signInWithGoogle(context);
                    if (user != null && context.mounted) {
                      replaceWith(context, Routes.bottomNavBar);
                    }
                  },
                ),
              ],
            ),
            const Gap(19),

            Center(
              child: GestureDetector(
                onTap: () {
                  replaceWith(context, Routes.signupScreen);
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: AppColors.gray39, fontSize: 12),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(color: AppColors.lightBlueButton),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
