import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class IconWithTextButton extends StatelessWidget {
  const IconWithTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPress,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final String text;
  final VoidCallback onPress;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPress,
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.mainGreen,
        foregroundColor: foregroundColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        elevation: 0,
      ),
    );
  }
}
