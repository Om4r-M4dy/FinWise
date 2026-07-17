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

class FingerprintScreen extends StatelessWidget {
  const FingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Fingerprint"),
      body: MyBodyView(
        bottomSection: Column(
          children: [
            const Gap(10),
            _FingerprintOption(
              icon: AppAssets.fingerprint,
              iconColor: Colors.white,
              bgColor: const Color(0xff6DB6FE),
              title: "John Fingerprint",
              onPress: () {
                pushTo(context, Routes.fingerprintDetailsScreen);
              },
            ),
            const Gap(10),
            _FingerprintOption(
              icon: null,
              iconWidget: const Icon(Icons.add, color: Colors.white, size: 22),
              bgColor: const Color(0xff6DB6FE),
              title: "Add A Fingerprint",
              onPress: () {
                pushTo(context, Routes.addFingerprintScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FingerprintOption extends StatelessWidget {
  const _FingerprintOption({
    required this.title,
    required this.bgColor,
    required this.onPress,
    this.icon,
    this.iconColor,
    this.iconWidget,
  });

  final String title;
  final String? icon;
  final Color? iconColor;
  final Color bgColor;
  final Widget? iconWidget;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        height: 42,
        width: 42,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: iconWidget ??
            CustomSvgPicture(
              path: icon!,
              color: iconColor,
            ),
      ),
      title: Text(title, style: TextStyles.bodyMedium),
      trailing: IconButton(
        onPressed: onPress,
        icon: Icon(
          Icons.arrow_forward_ios,
          weight: 7,
          color: AppColors.lettersAndIcons,
        ),
      ),
    );
  }
}
