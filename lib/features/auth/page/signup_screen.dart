import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/widgets/auth_layout.dart';
import 'package:finwise/features/auth/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/widgets/custom_auth_button.dart';
import 'package:finwise/features/auth/widgets/socialbutton.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final double space = 16;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user in Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user display name
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
      }

      if (mounted) {
        // Navigate to dashboard/home after successful signup
        replaceWith(context, Routes.bottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
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
      title: "Create Account",
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(27),
            Text(
              "Full name",
              style: TextStyles.caption1_14.copyWith(
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            AuthTextField(
              hintText: "Your Name",
              controller: _nameController,
            ),
            Gap(space),
            Text(
              "Email",
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
            Gap(space),

            /// Mobile Number
            Text(
              "Mobile Number",
              style: TextStyles.caption1_14.copyWith(
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            AuthTextField(
              hintText: "+ 123 456 789",
              controller: _phoneController,
            ),
            Gap(space),
            Text(
              "Date of birth",
              style: TextStyles.caption1_14.copyWith(
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            AuthTextField(
              hintText: "DD / MM /YYY",
              controller: _dobController,
            ),
            Gap(space),

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
            Gap(space),
            Text(
              "Confirm Password",
              style: TextStyles.caption1_14.copyWith(
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w500,
              ),
            ),
            AuthTextField(
              hintText: "Password",
              isPassword: true,
              controller: _confirmPasswordController,
            ),
            const Gap(28),
            const Center(child: Text("By continuing, you agree to ")),
            const Center(
              child: Text(
                "Terms of Use and Privacy Policy.,",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Gap(13),

            /// Sign Up Button
            CustomAuthButton(
              text: "Sign Up",
              onPressed: _signUp,
              isLoading: _isLoading,
            ),
            
            const Gap(28),
            const Center(child: Text("or sign up with")),
            const Gap(19),
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
                  replaceWith(context, Routes.loginScreen);
                },
                child: const Text("Already have an account? Log In"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
