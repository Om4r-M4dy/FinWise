import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/calculate_last_week_analysis.dart';
import 'package:finwise/core/functions/plot_helper.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/sections/plots_section.dart';
import 'package:finwise/core/widgets/shimmer/shimmer_loading.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/features/profile/persentation/cubit/user_state.dart';
import 'package:finwise/features/Home/persentation/widgets/last_week_analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class QuickAnalysisScreen extends StatelessWidget {
  const QuickAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txState = context.watch<TransactionCubit>().state;
    if (txState is TransactionLoadingState ||
        txState is TransactionInitialState) {
      return const Scaffold(
        appBar: DefaultAppBar(title: "Quickly Analysis"),
        body: QuickAnalysisShimmer(),
      );
    }

    final transactionsList = context
        .watch<TransactionCubit>()
        .statsTransactionsList;
    final userState = context.watch<UserCubit>().state;

    if (transactionsList.isEmpty) {
      return Scaffold(
        appBar: DefaultAppBar(title: "Quickly Analysis"),
        body: MyBodyView(
          clipBehavior: Clip.hardEdge,
          noPadding: true,
          topSection: Container(),
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(12),
                Text(
                  "Add income or expense transactions to view quick analysis.",
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.lettersAndIcons.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
              ],
            ),
          ),
        ),
      );
    }

    final now = DateTime.now();

    final lastWeekData = calculateLastWeekAnalysis(
      transactions: transactionsList,
      totalIncome: userState.income,
      totalExpense: userState.expense,
    );

    final double savingsPercent = lastWeekData['savingsPercent'] as double;
    final double revenueLastWeek = lastWeekData['revenue'] as double;

    final currentMonthName = DateFormat('MMMM').format(now);
    final dynamicChart = getDynamicChartData(transactionsList, 1);

    return Scaffold(
      appBar: DefaultAppBar(title: "Quickly Analysis"),
      body: MyBodyView(
        topSection: LastWeekAnalysis(
          revenue: revenueLastWeek,
          expenses: lastWeekData['expenses'] ?? 0.0,
          savingsPercent: savingsPercent,
          showBackground: false,
        ),
        bottomSection: SingleChildScrollView(
          child: Column(
            children: [
              PlotsSections(
                plotTitle: "$currentMonthName Expenses",
                chartData: dynamicChart.chartData,
                maxY: dynamicChart.maxY,
                bottomLabels: dynamicChart.labels,
              ),
              Gap(26),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionsList.length > 5
                    ? 5
                    : transactionsList.length,
                itemBuilder: (context, index) {
                  final tx = transactionsList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          index ==
                              (transactionsList.length > 5
                                  ? 4
                                  : transactionsList.length - 1)
                          ? 8.0
                          : 19.0,
                    ),
                    child: InfoRecord(
                      transaction: tx,
                      title: tx.title,
                      date: tx.formattedDate,
                      cat: tx.categoryName.isNotEmpty
                          ? tx.categoryName
                          : 'General',
                      amount: tx.getFormattedAmount(showPlusForIncome: true),
                      amountColor: tx.getAmountColor(useGreenForIncome: true),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
