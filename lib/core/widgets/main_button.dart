import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

enum ButtonSize {
  small(width: 169.0, height: 32.0),
  medium(width: 207.0, height: 45.0),
  large(width: double.infinity, height: 45.0);

  final double width;
  final double height;

  const ButtonSize({required this.width, required this.height});
}

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.text,
    required this.onPress,
    this.backgroundColor = AppColors.mainGreen,
    this.size = ButtonSize.medium,
  });

  final String text;
  final VoidCallback onPress;
  final Color backgroundColor;
  final ButtonSize size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        minimumSize: Size(size.width, size.height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: AppTextStyles.title_20,
      ),
    );
  }
}