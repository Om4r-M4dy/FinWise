import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/features/launch/build_auth_u_i.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:lottie/lottie.dart';

/// Standalone screen that shows after OnBoarding.
/// Gives the user the choice to Log In or Sign Up.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / branding at top
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    AppColors.mainGreen,
                    BlendMode.srcIn,
                  ),
                  child: Lottie.asset(
                    AppAssets.logoJson,
                    repeat: false,
                    height: 130,
                  ),
                ),
                const Gap(12),
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    AppColors.mainGreen,
                    BlendMode.srcIn,
                  ),
                  child: Lottie.asset(
                    AppAssets.finwiseJson,
                    repeat: false,
                    height: 50,
                  ),
                ),
                const Gap(40),

                // Auth buttons (Log In / Sign Up)
                const BuildAuthUI(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
