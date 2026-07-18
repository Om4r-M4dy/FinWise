import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnalysisHome extends StatelessWidget {
  const AnalysisHome({
    super.key,
    required this.icon,
    required this.title,
    required this.money,
    this.iconW,
    this.moneyColor,
    this.textColor,
    this.iconColor,
  });
  final String icon;
  final String title;
  final String money;
  final double? iconW;
  final Color? moneyColor;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final defaultColor = textColor ?? AppColors.lettersAndIcons;
    return Row(
      children: [
        CustomSvgPicture(
          path: icon,
          width: iconW,
          color: iconColor ?? AppColors.dark05,
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.bodySmall.copyWith(
                  color: defaultColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  money,
                  style: TextStyles.bodyMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: moneyColor ?? defaultColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
