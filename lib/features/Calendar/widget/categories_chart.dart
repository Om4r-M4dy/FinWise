import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/features/Calendar/widget/chart_legend_row.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// A fixed palette of colors for the chart sections, cycling if there are more categories
const List<Color> _chartColors = [
  AppColors.oceanBlueButton,
  AppColors.blueButton,
  AppColors.lightBlueButton,
  AppColors.mainGreen,
  AppColors.darkGreen,
  AppColors.darkModeIcon,
];

/// Pie chart representing category distribution inside the calendar dashboard.
///
/// Accepts a list of [TransactionModel] and computes the percentage breakdown
/// by category name. Shows an empty state when no data is provided.
class CategoriesChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const CategoriesChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pie_chart_outline_rounded,
                size: 56, color: AppColors.lettersAndIcons.withValues(alpha: 0.3)),
            const Gap(12),
            Text(
              'No category data for this day',
              style: TextStyle(
                color: AppColors.lettersAndIcons.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Group total amounts by category name
    final Map<String, double> categoryTotals = {};
    for (final tx in transactions) {
      final name = tx.categoryName.isEmpty ? 'Other' : tx.categoryName;
      categoryTotals[name] = (categoryTotals[name] ?? 0) + tx.amount;
    }

    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);
    final entries = categoryTotals.entries.toList();

    final sections = List<PieChartSectionData>.generate(entries.length, (i) {
      final percentage = (entries[i].value / total) * 100;
      final color = _chartColors[i % _chartColors.length];
      final showTitle = percentage >= 4;
      return PieChartSectionData(
        value: percentage,
        color: color,
        title: showTitle ? '${percentage.toStringAsFixed(0)}%' : '',
        showTitle: showTitle,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        radius: 40,
      );
    });

    final legendEntries = List<LegendEntry>.generate(
      entries.length,
      (i) {
        final percentage = (entries[i].value / total) * 100;
        return LegendEntry(
          color: _chartColors[i % _chartColors.length],
          text: '${entries[i].key} ${percentage.toStringAsFixed(0)}%',
        );
      },
    );

    return Column(
      children: [
        const Gap(30),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              startDegreeOffset: 270,
              centerSpaceRadius: 50,
              sectionsSpace: 3,
              sections: sections,
            ),
          ),
        ),
        const Gap(24),
        ChartLegendRow(entries: legendEntries),
      ],
    );
  }
}
