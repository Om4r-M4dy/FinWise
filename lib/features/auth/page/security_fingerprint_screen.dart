import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SecurityFingerprintScreen extends StatelessWidget {
  const SecurityFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainGreen,
      body: SafeArea(
        child: Column(
          children: [
            const Gap(30),
            Text(
              "Security Fingerprint",
              style: TextStyles.headlineLarge.copyWith(
                fontSize: 30,
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(30),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
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
                      decoration: const BoxDecoration(
                        color: AppColors.mainGreen,
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
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(16),
                    const Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing\nelit, sed do eiusmod tempor incididunt.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.gray39),
                    ),
                    const Gap(60),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          replaceWith(context, Routes.bottomNavBar);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightGreen,
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
                            color: AppColors.lettersAndIcons,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),
                    const Text(
                      "¿Or prefer use pin code?",
                      style: TextStyle(fontSize: 12, color: AppColors.gray39),
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
