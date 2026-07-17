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
  });
  final String title;
  final double percent;
  final double radius;
  final Widget? center;
  final TextStyle? titelStyle;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
            backgroundColor: AppColors.background,
            radius: radius,
            lineWidth: 5.0,
            percent: percent / 100,
            center:
                center ??
                Text("${(percent).toInt()}%", style: TextStyles.bodyLarge),
            progressColor: AppColors.oceanBlueButton,
          ),
          Gap(10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: titelStyle ?? TextStyles.bodyMedium.copyWith(
                    color: center != null
                        ? AppColors.dark05
                        : Color(0xffF1FFF3),
                  ),
          ),
        ],
      ),
    );
  }
}
