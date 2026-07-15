import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class TransactionBox extends StatelessWidget {
  const TransactionBox({
    super.key,
    this.pathIcon,
    required this.titel,
    required this.balance,
    this.iconColor,
    this.balanceColor,
    this.isSelected = false,
    required this.onTap,
  });

  final String? pathIcon;
  final String titel;
  final String balance;
  final Color? iconColor;
  final Color? balanceColor;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.oceanBlueButton
                : AppColors.background,
            borderRadius: BorderRadius.circular(14),
          ),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSvgPicture(
                height: 25,
                width: 25,
                path: pathIcon ?? '',
                color: isSelected ? AppColors.background : iconColor,
              ),
              Text(
                titel,
                style: TextStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? AppColors.background
                      : AppColors.lettersAndIcons,
                ),
              ),
              Text(
                '\$$balance',
                style: TextStyles.bodyLarge.copyWith(
                  color: isSelected
                      ? AppColors.background
                      : balanceColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
