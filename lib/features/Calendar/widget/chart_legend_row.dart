import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Legend for the category chart representing color mapping.
///
/// Kept minimal for consistency with visual chart values and fixed labels.
class ChartLegendRow extends StatelessWidget {
  const ChartLegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        ChartIndicator(color: AppColors.oceanBlueButton, text: 'Others'),
        Gap(37),
        ChartIndicator(color: AppColors.blueButton, text: 'Groceries'),
      ],
    );
  }
}

/// Individual legend entry with color swatch and label.
///
/// Used by `ChartLegendRow` to keep indicator rendering consistent with chart sections.
class ChartIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const ChartIndicator({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyles.caption1_14.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
