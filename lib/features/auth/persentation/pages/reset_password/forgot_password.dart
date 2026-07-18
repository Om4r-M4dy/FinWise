import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_layout.dart';
import 'package:finwise/features/auth/persentation/widgets/loading_overlay.dart';
import 'package:finwise/features/auth/persentation/widgets/custom_auth_button.dart';
import 'package:finwise/features/auth/persentation/widgets/reset_success_bottom_sheet.dart';
import 'package:finwise/features/auth/persentation/widgets/socialbutton.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

    // Basic email format validation
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔵 [ForgotPassword] Sending reset email to: $email');
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      debugPrint('✅ [ForgotPassword] Reset email sent successfully!');
      if (mounted) {
        _showSuccessBottomSheet(email);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '🔴 [ForgotPassword] FirebaseAuthException: code=${e.code}, message=${e.message}',
      );
      if (mounted) {
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No account found with this email address.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is badly formatted.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Too many requests. Please try again later.';
        } else if (e.code == 'network-request-failed') {
          errorMessage = 'No internet connection. Please check your network.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage\n(code: ${e.code})'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint('🔴 [ForgotPassword] Unknown error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
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

  void _showSuccessBottomSheet(String email) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      backgroundColor: isDark ? AppColors.dark05 : AppColors.background,
      builder: (ctx) => ResetSuccessBottomSheet(
        email: email,
        onBackToLogin: () {
          Navigator.pop(ctx); // close bottom sheet
          replaceWith(context, Routes.loginScreen);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        AuthLayout(
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
                    color: isDark ? Colors.white : AppColors.lettersAndIcons,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(10),
                Text(
                  "Enter your registered email address below and we'll send you a link to reset your password.",
                  style: TextStyles.caption1_14.copyWith(
                    color: isDark ? Colors.white70 : AppColors.lettersAndIcons,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const Gap(40),
                Text(
                  "Enter Email Address",
                  style: TextStyles.caption1_14.copyWith(
                    color: isDark ? Colors.white : AppColors.lettersAndIcons,
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

                /// Send Reset Email Button
                CustomAuthButton(
                  text: "Send Reset Link",
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
                  backgroundColor: isDark ? AppColors.darkGreen : AppColors.lightGreen,
                  textColor: isDark ? Colors.white : AppColors.lettersAndIcons,
                ),

                const Gap(28),
                Center(
                  child: Text(
                    "or sign up with",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : AppColors.lettersAndIcons,
                    ),
                  ),
                ),
                const Gap(19),

                // google && facebook
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(
                      icon: AppAssets.facebook,
                      onTap: () async {
                        final user =
                            await FacebookAuthService.signInWithFacebook(
                              context,
                            );
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
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.gray39,
                          fontSize: 12,
                        ),
                        children: const [
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
        ),

        /// Full-screen loading overlay
        LoadingOverlay(isLoading: _isLoading, message: "Sending reset link..."),
      ],
    );
  }
}
