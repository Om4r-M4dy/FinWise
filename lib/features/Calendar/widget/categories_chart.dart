import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/context_extensions.dart';
import 'package:finwise/features/calendar/widget/chart_legend_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Pie chart representing category distribution inside the calendar dashboard.
///
/// Includes an invisible pie section to reserve visual spacing and keep the
/// displayed slices aligned with the legend semantics.
class CategoriesChart extends StatelessWidget {
  const CategoriesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(context.screenHeight * 0.12),

        Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.5,
          child: AspectRatio(
            aspectRatio: 2,
            child: PieChart(
              PieChartData(
                startDegreeOffset: 0,
                centerSpaceRadius: 0,
                sectionsSpace: 3,
                
                sections: [
                  // A transparent padding slice is used to control the visual center
                  // and effectively create a donut-like gap for the chart layout.
                  PieChartSectionData(
                    value: 100,
                    color: Colors.transparent,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 10,
                    color: AppColors.oceanBlueButton,
                    title: '10%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 145,
                  ),
                  PieChartSectionData(
                    value: 11,
                    color: AppColors.lightBlueButton,
                    title: '11%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 145,
                  ),
                  PieChartSectionData(
                    value: 79,
                    color: AppColors.blueButton,
                    title: '79%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 145,
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(16),
        ChartLegendRow(),
      ],
    );
  }
}
