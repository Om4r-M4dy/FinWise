import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileOption extends StatelessWidget {
  const ProfileOption({
    super.key,
    required this.path,
    required this.title,
    this.onTap,
  });

  final String title;
  final String path;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip
          .antiAlias, // prevents the ripple from bleeding outside the rounded corners
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            AppIconButton(
              path: path,
              bgWidth: 57,
              bgHeight: 53,
              iconColor: AppColors.background,
              borderRadius: 22,
            ),
            Gap(13),
            Text(title, style: TextStyles.body_15),
          ],
        ),
      ),
    );
  }
}
