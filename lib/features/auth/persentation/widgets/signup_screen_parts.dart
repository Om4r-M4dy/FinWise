import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/persentation/widgets/socialbutton.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A reusable label + field widget used across the signup form.
class LabeledField extends StatelessWidget {
  final String label;
  final Widget field;
  final double gapAfter;
  const LabeledField({
    required this.label,
    required this.field,
    this.gapAfter = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.caption1_14.copyWith(
            color: isDark ? Colors.white : AppColors.lettersAndIcons,
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        field,
        Gap(gapAfter),
      ],
    );
  }
}

/// Row containing Facebook and Google social login buttons.
class SocialButtonsRow extends StatelessWidget {
  const SocialButtonsRow({super.key});

  Future<void> _handleSocialSignIn(
    BuildContext context,
    Future<UserCredential?> Function(BuildContext) signInMethod,
  ) async {
    final user = await signInMethod(context);
    if (user != null && context.mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', user.user?.displayName ?? '');
      if (context.mounted) {
        replaceWith(context, Routes.bottomNavBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          icon: AppAssets.facebook,
          onTap: () => _handleSocialSignIn(
            context,
            FacebookAuthService.signInWithFacebook,
          ),
        ),
        const Gap(16),
        SocialButton(
          icon: AppAssets.google,
          onTap: () =>
              _handleSocialSignIn(context, GoogleAuth.signInWithGoogle),
        ),
      ],
    );
  }
}

/// Terms and privacy notice widget.
class TermsNotice extends StatelessWidget {
  const TermsNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : AppColors.lettersAndIcons;
    return Column(
      children: [
        Center(
          child: Text(
            "By continuing, you agree to ",
            style: TextStyle(color: textColor),
          ),
        ),
        Center(
          child: Text(
            "Terms of Use and Privacy Policy.",
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
          ),
        ),
        const Gap(13),
      ],
    );
  }
}

/// "Already have an account?" navigation link.
class AlreadyAccountLink extends StatelessWidget {
  const AlreadyAccountLink({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: GestureDetector(
        onTap: () => replaceWith(context, Routes.loginScreen),
        child: Text.rich(
          TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.gray39,
              fontSize: 14,
            ),
            children: const [
              TextSpan(
                text: "Log In",
                style: TextStyle(
                  color: AppColors.lightBlueButton,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
