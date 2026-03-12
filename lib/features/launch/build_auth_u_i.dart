import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuildAuthUI extends StatelessWidget {
  const BuildAuthUI({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Personalized financial insights\nat your fingertips.',
          textAlign: TextAlign.center,
          style: TextStyles.caption1_14.copyWith(
            color: AppColors.darkModeIcon,
          ),
        ),
        const Gap(42),
        MainButton(text: 'Log In', onPress: () {}),
        const Gap(12),
        MainButton(
          text: 'Sign Up',
          onPress: () {},
          backgroundColor: AppColors.lightGreen,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Forgot Password?",
            style: TextStyles.caption1_14.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}