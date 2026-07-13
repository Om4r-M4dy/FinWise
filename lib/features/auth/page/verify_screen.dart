import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:finwise/features/auth/widgets/auth_layout.dart';
import 'package:finwise/features/auth/widgets/custom_auth_button.dart';
import 'package:finwise/core/functions/navigations.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool _isResending = false;
  bool _checking = false;

  Future<void> _resendVerification() async {
    setState(() => _isResending = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isResending = false);
    }
  }

  Future<void> _checkVerification() async {
    setState(() => _checking = true);
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      if (mounted) {
        pushTo(context, Routes.bottomNavBar);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email not verified yet')));
    }
    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Verify Email',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(30),
          Text(
            'A verification link has been sent to your email.\nPlease check your inbox and verify your account.',
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.lettersAndIcons,
            ),
          ),
          const Gap(40),
          CustomAuthButton(
            text: _isResending ? 'Resending...' : 'Resend Email',
            onPressed: _isResending ? null : _resendVerification,
            isLoading: _isResending,
          ),
          const Gap(20),
          CustomAuthButton(
            text: _checking ? 'Checking...' : 'I have verified',
            onPressed: _checking ? null : _checkVerification,
            backgroundColor: AppColors.lightGreen,
            isLoading: _checking,
          ),
        ],
      ),
    );
  }
}
