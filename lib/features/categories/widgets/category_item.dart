import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    this.bgColor = AppColors.oceanBlueButton,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Color bgColor;
  final String icon;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              height: 98,
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: CustomSvgPicture(
                height: 54,
                width: 30,
                path: icon,
              ),
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyles.body_15
            ),
          ],
        ),
      ),
    );
  }
}
