import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/widgets/socialbutton.dart';
import 'package:finwise/features/auth/widgets/auth_layout.dart';
import 'package:finwise/features/auth/widgets/custom_auth_button.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        replaceWith(context, Routes.bottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is badly formatted.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
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
      title: "Welcome",
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(90),

            /// Username
            Text(
              "Username Or Email",
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

            const Gap(20),

            /// Password
            Text(
              "Password",
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

            /// Login Button
            CustomAuthButton(
              text: "Log In",
              onPressed: _login,
              isLoading: _isLoading,
            ),

            const Gap(10),

            /// Forgot password
            Center(
              child: TextButton(
                onPressed: () {
                  pushTo(context, Routes.forgotPasswordScreen);
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyles.caption1_14.copyWith(
                    color: AppColors.lettersAndIcons,
                    fontFamily: AppFonts.leagueSpartan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const Gap(10),

            /// Sign Up button
            CustomAuthButton(
              text: "Sign Up",
              onPressed: () {
                replaceWith(context, Routes.signupScreen);
              },
              backgroundColor: AppColors.lightGreen,
            ),

            const Gap(20),

            /// Fingerprint
            const Center(
              child: Text.rich(
                TextSpan(
                  text: "Use ",
                  children: [
                    TextSpan(
                      text: "Fingerprint",
                      style: TextStyle(color: AppColors.blueButton),
                    ),
                    TextSpan(text: " To Access"),
                  ],
                ),
              ),
            ),
            const Gap(28),
            const Center(child: Text("or sign up with")),
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
            const Center(child: Text("Don’t have an account? Sign Up")),
          ],
        ),
      ),
    );
  }
}
