import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class SecurityFingerprintScreen extends StatelessWidget {
  const SecurityFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            const Gap(30),
            Text(
              "Security Fingerprint",
              style: TextStyles.headlineLarge.copyWith(
                fontSize: 30,
                color: isDark ? Colors.white : AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(30),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).colorScheme.surface
                      : AppColors.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.darkGreen : AppColors.mainGreen,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.fingerprint,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const Gap(40),
                    Text(
                      "Use Fingerprint To Access",
                      style: TextStyles.headlineLarge.copyWith(
                        fontSize: 20,
                        color:
                            isDark ? Colors.white : AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      "Secure your account with your fingerprint for faster and safer access.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppColors.gray39,
                      ),
                    ),
                    const Gap(60),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          final fingerprintName = UserPrefs.getFingerprintName();
                          if (fingerprintName != null && fingerprintName.isNotEmpty) {
                            replaceWith(context, Routes.bottomNavBar);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No fingerprint registered. Please register a fingerprint in Settings."),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.darkGreen
                              : AppColors.lightGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Use Touch Id",
                          style: TextStyles.headlineLarge.copyWith(
                            fontSize: 18,
                            color: isDark
                                ? Colors.white
                                : AppColors.lettersAndIcons,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),
                    GestureDetector(
                      onTap: () {
                        replaceWith(context, Routes.securitypinScreen);
                      },
                      child: Text(
                        "Or prefer using a pin code?",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppColors.gray39,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
