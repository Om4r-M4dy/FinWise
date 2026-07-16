import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/core/functions/calculate_budget_percentage.dart';
import 'package:finwise/core/functions/is_category_match.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final budget = userState.budget;
        final expense = userState.expense;
        final balance = userState.balance;
        final transactionsList = context.watch<TransactionCubit>().transactionsList;
        
        final monthlyExpense = context.watch<TransactionCubit>().monthlyExpenses;
        final percentage = calculateBudgetPercentage(monthlyExpense, budget);

        if (transactionsList.isEmpty) {
          return MyBodyView(
            clipBehavior: Clip.hardEdge,
            noPadding: true,
            topSection: ProgressSection(
              percentage: 0.0,
              totalAmount: budget,
              totalExpense: expense,
              totalBalance: balance,
            ),
            bottomSection: Container(
              padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 40),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(40),
                  Opacity(
                    opacity: 0.15,
                    child: CustomSvgPicture(
                      path: AppAssets.analysis,
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const Gap(24),
                  Text(
                    "No transactions to analyze",
                    style: TextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.lettersAndIcons,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(12),
                  Text(
                    "Add income or expense transactions to unlock detailed charts, budget tracking, and savings targets.",
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.lettersAndIcons.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(30),
                  ElevatedButton(
                    onPressed: () {
                      pushTo(context, Routes.addTransaction);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainGreen,
                      foregroundColor: const Color(0xff093030),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Add Transaction",
                      style: TextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff093030),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final dynamicChart = getDynamicChartData(transactionsList, index);

        double calculateTargetPercent(String categoryName, double goal) {
          final total = transactionsList
              .where((tx) => isCategoryMatch(tx, categoryName))
              .fold(0.0, (sum, tx) => sum + tx.amount);
          if (goal <= 0) return 0.0;
          return ((total / goal) * 100).clamp(0.0, 100.0);
        }

        final targets = [
          {
            "title": "Travel",
            "categoryKey": "Travel",
            "percent": calculateTargetPercent("Travel", 20000.0),
            "radius": 30.0
          },
          {
            "title": "Car",
            "categoryKey": "Transport",
            "percent": calculateTargetPercent("Transport", 20000.0),
            "radius": 30.0
          },
          {
            "title": "New House",
            "categoryKey": "Rent",
            "percent": calculateTargetPercent("Rent", 20000.0),
            "radius": 30.0
          },
          {
            "title": "Wedding",
            "categoryKey": "Other",
            "percent": calculateTargetPercent("Other", 20000.0),
            "radius": 30.0
          },
        ];

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
                        labels: const ["Daily", "Weekly", "Monthly"],
                        onUpdate: (value) {
                          setState(() {
                            index = value;
                          });
                        },
                      ),
                      Gap(30),
                      PlotsSections(
                        chartData: dynamicChart.chartData,
                        maxY: dynamicChart.maxY,
                        bottomLabels: dynamicChart.labels,
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
                    itemCount: targets.length,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(left: 6, right: 6),
                        child: SizedBox(
                          width: 150,
                          child: GestureDetector(
                            onTap: () {
                              final filtered = transactionsList
                                  .where((tx) => isCategoryMatch(tx, targets[i]["categoryKey"] as String))
                                  .toList();
                              pushTo(
                                context,
                                Routes.foodScreen,
                                extra: {
                                  'categoryName': targets[i]["title"] as String,
                                  'transactions': filtered,
                                },
                              );
                            },
                            child: TargetCard(
                              title: targets[i]["title"] as String,
                              percent: targets[i]["percent"] as double,
                              radius: targets[i]["radius"] as double,
                            ),
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
