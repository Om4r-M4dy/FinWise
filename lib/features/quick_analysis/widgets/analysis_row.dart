import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnalysisRow extends StatelessWidget {
  const AnalysisRow({
    super.key,
    required this.icon,
    required this.title,
    required this.money,
    this.iconW,
    this.moneyColor,
  });
  final String icon;
  final String title;
  final String money;
  final double? iconW;
  final Color? moneyColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSvgPicture(path: icon, width: iconW, color: AppColors.dark05),
        Gap(17),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.caption3_12.copyWith(
                color: AppColors.lettersAndIcons,
              ),
            ),
            Text(
              money,
              style: TextStyles.body_15.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: moneyColor ?? AppColors.lettersAndIcons,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
