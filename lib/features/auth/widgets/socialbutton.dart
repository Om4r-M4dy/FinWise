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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.lettersAndIcons),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }
}