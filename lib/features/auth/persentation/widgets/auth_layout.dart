import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/styles/text_styles.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const AuthLayout({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          const Gap(68),
          Text(
            title,
            style: TextStyles.size_30.copyWith(
              color: isDark ? Colors.white : AppColors.lettersAndIcons,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(65),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(38),
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).colorScheme.surface
                    : AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
