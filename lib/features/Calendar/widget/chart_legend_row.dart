import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

/// A model representing a single legend entry (label + color).
class LegendEntry {
  final Color color;
  final String text;
  const LegendEntry({required this.color, required this.text});
}

/// Legend for the category chart representing color mapping.
///
/// Accepts a dynamic list of [LegendEntry] objects so the legend always
/// matches the current data shown in the pie chart.
class ChartLegendRow extends StatelessWidget {
  final List<LegendEntry> entries;

  const ChartLegendRow({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: entries.map((e) => ChartIndicator(color: e.color, text: e.text)).toList(),
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
          style: TextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
