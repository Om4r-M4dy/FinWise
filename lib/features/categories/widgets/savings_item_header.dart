import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SavingsItemHeader extends StatelessWidget {
  const SavingsItemHeader({super.key, required this.goal, required this.amountSaved, required this.savingsIcon, required this.savingsLabel});

  final String goal;
  final String amountSaved;
  final String savingsIcon;
  final String savingsLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomSvgPicture(path: AppAssets.goal),
                Gap(1),
                Text(
                  "Goal",
                  style: TextStyles.caption3_12.copyWith(
                    color: Color(0xff052224),
                  ),
                ),
              ],
            ),
            Gap(3),
            Text(
goal,              style: TextStyles.headline_24.copyWith(color: Color(0xff052224)),
            ),
            Gap(3),
            Row(
              children: [
                CustomSvgPicture(path: AppAssets.amountSaved),
                Gap(1),
                Text(
                  "Amount Saved",
                  style: TextStyles.caption3_12.copyWith(
                    color: Color(0xff052224),
                  ),
                ),
              ],
            ),
            Gap(3),
            Text(
             amountSaved,
              style: TextStyles.headline_24.copyWith(
                color: AppColors.mainGreen,
              ),
            ),
          ],
        ),
        Gap(30),
        Container(
          height: 167,
          width: 169,
          decoration: BoxDecoration(
            color: AppColors.lightBlueButton,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
              top: 25,
              bottom: 10,
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomSvgPicture(
                      path: savingsIcon,
                      height: 30,
                      width: 55,
                    ),
                    CustomSvgPicture(
                      path: AppAssets.travelCirlce,
                      height: 107,
                      width: 107,
                    ),
                  ],
                ),
                Text(
                  savingsLabel,
                  style: TextStyles.body_15.copyWith(
                    color: AppColors.background,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
