import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    this.bgColor = AppColors.oceanBlueButton,
    this.icon,
    this.iconWidget,
    required this.label,
    this.onTap,
  });

  final Color bgColor;
  final String? icon;
  final Widget? iconWidget;
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              height: 98,
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: iconWidget ?? CustomSvgPicture(height: 54, width: 30, path: icon!),
              ),
            ),
            const SizedBox(height: 3),
            Text(label, style: TextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
