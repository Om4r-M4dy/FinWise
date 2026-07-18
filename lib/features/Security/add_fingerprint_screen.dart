import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddFingerprintScreen extends StatelessWidget {
  const AddFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const DefaultAppBar(title: "Add Fingerprint"),
      body: MyBodyView(
        bottomSection: Column(
          children: [
            const Gap(40),
            Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: AppColors.mainGreen,
                shape: BoxShape.circle,
              ),
              child: const CustomSvgPicture(
                path: AppAssets.fingerprint,
                color: Colors.white,
              ),
            ),
            const Gap(40),
            Text(
              "Use Fingerprint To Access",
              style: TextStyles.headlineLarge.copyWith(
                fontSize: 20,
                color: isDark ? Colors.white : AppColors.lettersAndIcons,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing\nelit, sed do eiusmod tempor incididunt.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white.withValues(alpha: 0.7) : AppColors.gray39,
              ),
            ),
            const Gap(40),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () async {
                  await UserPrefs.setFingerprintName("My Fingerprint");
                  if (context.mounted) {
                    replaceWith(context, Routes.loadingChangeFingerScreen);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkGreen : const Color(0xffE9F6ED),
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
                    color: isDark ? Colors.white : AppColors.lettersAndIcons,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
