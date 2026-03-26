import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/app_icon_button.dart';
import 'package:finwise/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key});
  final double? cardHeight = 86;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Gap(14),
          AppIconButton(
            path: AppAssets.food,
            bgWidth: 57,
            bgHeight: 53,
            iconWidth: 16,
            iconHeight: 28,
            borderRadius: 22,
          ),
          Gap(19),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dinner',
                style: TextStyles.body_15,
                textAlign: TextAlign.start,
              ),
              Gap(2),
              Text(
                '18:27 - April 30',
                style: TextStyles.caption3_12.copyWith(
                  color: AppColors.oceanBlueButton,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            '-\$26,00',
            style: TextStyles.body_15.copyWith(
              color: AppColors.oceanBlueButton,
            ),
          ),
          Gap(12),
        ],
      ),
    );
  }
}
