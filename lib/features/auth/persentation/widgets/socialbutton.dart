import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finwise/core/constants/app_colors.dart';

class SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.darkGreen : Colors.transparent,
          border: Border.all(
            color: isDark ? Colors.white38 : AppColors.lettersAndIcons,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }
}