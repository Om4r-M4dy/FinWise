import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddFingerprintScreen extends StatelessWidget {
  const AddFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.lettersAndIcons,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing\nelit, sed do eiusmod tempor incididunt.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.gray39),
            ),
            const Gap(40),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  // handle use touch id
                  replaceWith(context, Routes.loadingChangeFingerScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE9F6ED),
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
