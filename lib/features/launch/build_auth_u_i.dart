import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuildAuthUI extends StatelessWidget {
  const BuildAuthUI({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Personalized financial insights\nat your fingertips.',
          textAlign: TextAlign.center,
          style: TextStyles.bodySmall.copyWith(
            color: isDark
                ? Colors.white.withValues(alpha: 0.8)
                : AppColors.darkModeIcon,
          ),
        ),
        const Gap(42),
        MainButton(
          text: 'Log In',
          onPress: () {
            replaceWith(context, Routes.loginScreen);
          },
        ),
        const Gap(12),
        MainButton(
          text: 'Sign Up',
          onPress: () {
            replaceWith(context, Routes.signupScreen);
          },
          backgroundColor: isDark ? AppColors.darkGreen : AppColors.lightGreen,
          textColor: isDark ? Colors.white : AppColors.lettersAndIcons,
        ),
      ],
    );
  }
}
