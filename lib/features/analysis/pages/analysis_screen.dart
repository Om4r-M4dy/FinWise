import 'package:finwise/core/functions/plot_helper.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/income_expense_row.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/plots_section.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/core/widgets/target_card.dart';
import 'package:finwise/features/analysis/widgets/date_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int index = 0;
  final List<Map<String, dynamic>> _mytargets = [
    {"title": "Travel", "percent": 30.0, "radius": 30.0},
    {"title": "Car", "percent": 50.0, "radius": 30.0},
    {"title": "Emergency Fund", "percent": 50.0, "radius": 30.0},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final budget = userState.budget;
        final expense = userState.expense;
        final balance = userState.balance;
        final percentage = userState.budgetPercentage;

        return MyBodyView(
          clipBehavior: Clip.hardEdge,
          noPadding: true,
          topSection: ProgressSection(
            percentage: percentage,
            totalAmount: budget,
            totalExpense: expense,
            totalBalance: balance,
          ),
          bottomSection: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 37.0,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      DateHeader(
                        selectedIndex: index,
                        labels: ["Daily", "Weekly", "Monthly"],
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
                      Text(
                        "My Targets",
                        style: TextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 180,

                  child: ListView.builder(
                    itemCount: _mytargets.length,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(left: 6, right: 6),
                        child: SizedBox(
                          width: 150,
                          child: TargetCard(
                            title: _mytargets[i]["title"],
                            percent: _mytargets[i]["percent"],
                            radius: _mytargets[i]["radius"],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
