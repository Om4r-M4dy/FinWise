import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TargetCard extends StatelessWidget {
  const TargetCard({
    super.key,
    required this.title,
    required this.percent,
    this.center,
    required this.radius,
    this.titelStyle,
    this.backgroundColor,
    this.circleBackgroundColor,
  });
  final String title;
  final double percent;
  final double radius;
  final Widget? center;
  final TextStyle? titelStyle;
  final Color? backgroundColor;
  final Color? circleBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 0),
            blurRadius: 4,
          ),
        ],
        color: backgroundColor ?? (center != null ? null : AppColors.lightBlueButton),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            backgroundColor: circleBackgroundColor ?? (isDark ? AppColors.darkGreen : AppColors.background),
            radius: radius,
            lineWidth: 5.0,
            percent: (percent.clamp(0.0, 100.0)) / 100,
            center:
                center ??
                Text("${(percent).toInt()}%", style: TextStyles.bodyLarge.copyWith(
                  color: isDark ? Colors.white : AppColors.dark05,
                )),
            progressColor: AppColors.oceanBlueButton,
          ),
          const Gap(10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titelStyle ?? TextStyles.bodyMedium.copyWith(
                    color: center != null
                        ? (isDark ? Colors.white : AppColors.dark05)
                        : const Color(0xffF1FFF3),
                  ),
          ),
        ],
      ),
    );
  }
}
