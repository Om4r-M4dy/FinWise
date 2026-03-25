import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SavingsSubItem extends StatelessWidget {
  const SavingsSubItem({
    this.bgColor = AppColors.lightBlueButton,
    required this.icon,
    required this.label,
    super.key,
    this.height = 90,
    this.width = double.infinity,required this.onTap,
  });
  final Color bgColor;
  final String icon;
  final String label;
  final double height;
  final double width;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: CustomSvgPicture(height: 35, width: 65, path: icon),
          ),
          Gap(1),
          Text(
            label,
            style: TextStyles.body_15.copyWith(color: AppColors.lettersAndIcons),
          ),
        ],
      ),
    );
  }
}
