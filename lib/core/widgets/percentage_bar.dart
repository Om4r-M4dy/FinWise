import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class PercentageBar extends StatelessWidget {
  const PercentageBar({
    super.key,
    required this.percentage,
    required this.totalAmount,
  });
  final double percentage;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Container(
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.background,
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
                  padding: const EdgeInsets.symmetric(horizontal: 21,vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${(value * 100).toInt()}%",
                           textAlign: TextAlign.center,
                        style: TextStyles.caption3_12.copyWith(
                          color: color,
                          ),
                      ),
                      Text(
                        "\$ ${totalAmount.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: TextStyles.caption2_13.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  buildLabels(AppColors.dark05),
                  Container(
                    width: currentProgressWidth,
                    decoration: BoxDecoration(
                      color: AppColors.dark05,
                      borderRadius: BorderRadius.circular(13.5),
                    ),
                  ),
                  ClipRect(
                    child:Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: SizedBox(
                        width: maxWidth,
                        child: buildLabels(AppColors.background),
                      ),
                    ) ,)
             ],
              );
            },
          ),
        );
      },
    );
  }
}
