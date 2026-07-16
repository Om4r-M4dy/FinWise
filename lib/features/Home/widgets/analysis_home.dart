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
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.lettersAndIcons,
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
                    color: moneyColor ?? AppColors.lettersAndIcons,
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
