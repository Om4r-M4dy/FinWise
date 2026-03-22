import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/income_expense_row.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/plots_section.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/analysis/widgets/target_card.dart';
import 'package:finwise/features/analysis/widgets/date_header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int index = 0;

  BarChartGroupData _buildGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: AppColors.mainGreen,
          width: 8,
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          toY: y2,
          color: AppColors.oceanBlueButton,
          width: 8,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  List<BarChartGroupData> _getCurrentChartData(int index) {
    switch (index) {
      case 0: // Day
        return [_buildGroup(0, 5, 2), _buildGroup(1, 3, 8)];
      case 1: // Week
        return [
          _buildGroup(0, 10, 12),
          _buildGroup(1, 15, 5),
          _buildGroup(2, 10, 12),
          _buildGroup(5, 15, 5),
        ];
      default:
        return [];
    }
  }

  double _calculateMaxY(int index) {
    List<BarChartGroupData> currentData = _getCurrentChartData(index);
    if (currentData.isEmpty) return 20.0;
    double maxVal = 0;
    for (var group in currentData) {
      for (var rod in group.barRods) {
        if (rod.toY > maxVal) {
          maxVal = rod.toY;
        }
      }
    }
    return maxVal == 0 ? 20.0 : maxVal * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Analysis"),
      body: MyBodyView(
        topSection: ProgressSection(
          percentage: 30,
          totalAmount: 20000.00,
          totalExpanse: 1187.40,
          totalBalance: 7783.00,
        ),
        bottomSection: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateHeader(
              selectedIndex: index,
              labels: ["Daily", "Weekly", "Monthly", "Year"],
              onUpdate: (value) {
                setState(() {
                  index = value;
                });
              },
            ),
            Gap(30),
            PlotsSections(
              chartData: _getCurrentChartData(index),
              maxY: _calculateMaxY(index),
            ),
            Gap(30),
            IncomeExpenseRow(),
            Gap(33),
            Text("My Targets", style: TextStyles.body_15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 169,
                      height: 167,
                      child: TargetCard(title: "Travel", percent: .3),
                    ),
                    Gap(20),

                    SizedBox(
                      width: 169,
                      height: 167,
                      child: TargetCard(title: "Car", percent: .5),
                    ),
                    Gap(20),
                    SizedBox(
                      width: 169,
                      height: 167,
                      child: TargetCard(title: "Car", percent: .5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
