import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class PercentageBar extends StatelessWidget {
  const PercentageBar({
    super.key,
    required this.percentage,
    required this.totalAmount,
    this.bgColor,
  });
  final double percentage;
  final double totalAmount;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedBgColor = bgColor ?? (isDark ? AppColors.darkGreen : AppColors.background);
    final progressColor = isDark ? AppColors.mainGreen : AppColors.dark05;
    final textNonFilledColor = isDark ? Colors.white : AppColors.dark05;
    final textFilledColor = isDark ? AppColors.lettersAndIcons : AppColors.background;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Container(
          height: 28,
          decoration: BoxDecoration(
            color: resolvedBgColor,
            borderRadius: BorderRadius.circular(13.5),
          ),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: percentage / 100),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            builder: (context, value, child) {
              double currentProgressWidth = maxWidth * value;
              Widget buildLabels(Color color) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 21,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${(value * 100).toInt()}%",
                        textAlign: TextAlign.center,
                        style: TextStyles.bodySmall.copyWith(color: color),
                      ),
                      Text(
                        "\$ ${totalAmount.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: TextStyles.bodySmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  buildLabels(textNonFilledColor),
                  Container(
                    width: currentProgressWidth,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(13.5),
                    ),
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: SizedBox(
                        width: maxWidth,
                        child: buildLabels(textFilledColor),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
