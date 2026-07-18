import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_layout.dart';
import 'package:finwise/features/auth/persentation/widgets/custom_auth_button.dart';
import 'package:finwise/features/auth/persentation/widgets/loading_overlay.dart';

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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Future<void> _checkVerification() async {
    setState(() => _checking = true);
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      if (mounted) {
        replaceWith(context, Routes.bottomNavBar);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Email not verified yet')));
      }
    }
    if (mounted) {
      setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        AuthLayout(
          title: 'Verify Email',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              Text(
                'A verification link has been sent to your email.\nPlease check your inbox and verify your account.',
                style: TextStyles.bodyLarge.copyWith(
                  color: isDark ? Colors.white : AppColors.lettersAndIcons,
                ),
              ),
              const Gap(40),
              CustomAuthButton(
                text: 'Resend Email',
                onPressed: _isResending ? null : _resendVerification,
              ),
              const Gap(20),
              CustomAuthButton(
                text: 'I have verified',
                onPressed: _checking ? null : _checkVerification,
                backgroundColor: isDark ? AppColors.darkGreen : AppColors.lightGreen,
                textColor: isDark ? Colors.white : AppColors.lettersAndIcons,
              ),
            ],
          ),
        ),
        LoadingOverlay(
          isLoading: _isResending || _checking,
          message: _isResending ? "Resending..." : "Checking...",
        ),
      ],
    );
  }
}
