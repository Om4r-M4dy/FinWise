import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({
    super.key,
    this.bgColor = AppColors.oceanBlueButton,
    required this.icon,  this.verticalPadding = 13,  this.horizontalPadding = 21,
  });
  final Color bgColor;
  final String icon;
  final double verticalPadding;
  final double horizontalPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      height: 53,
      width: 57,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: CustomSvgPicture(height: 27, width: 15, path: icon),
    );
  }
}
