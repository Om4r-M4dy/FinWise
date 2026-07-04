import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FingerprintDetailsScreen extends StatelessWidget {
  const FingerprintDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: "Jhon Fingerprint"),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xffE9F6ED),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  "Jhon Fingerprint",
                  style: TextStyles.bodyMedium,
                ),
              ),
            ),
            const Gap(40),
            MainButton(
              text: "Delete",
              onPress: () {
                replaceWith(context, Routes.loadingDeletedFingerprintScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
