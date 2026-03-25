import 'package:finwise/core/functions/plot_helper.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/income_expense_row.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/plots_section.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/core/widgets/target_card.dart';
import 'package:finwise/features/analysis/widgets/date_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int index = 0;


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
        bottomSection: SingleChildScrollView(
          child: Column(
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
                chartData: getCurrentChartData(index),
                maxY: calculateMaxY(index),
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
                        child: TargetCard(title: "Travel", percent: 30),
                      ),
                      Gap(20),
          
                      SizedBox(
                        width: 169,
                        height: 167,
                        child: TargetCard(title: "Car", percent: 50),
                      ),
                      Gap(20),
                      SizedBox(
                        width: 169,
                        height: 167,
                        child: TargetCard(title: "Car", percent: 50),
                      ),
                    ],
                  ),
                ),
              ),
          
          
            ],
          ),
        ),
      ),
    );
  }
}
