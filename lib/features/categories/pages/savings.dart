import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/core/widgets/add_goal_bottom_sheet.dart';
import 'package:finwise/features/categories/widgets/savings_sub_item.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:finwise/features/analysis/cubit/goal_cubit.dart';
import 'package:finwise/features/analysis/cubit/goal_state.dart';
import 'package:finwise/features/analysis/data/model/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class Savings extends StatelessWidget {
  const Savings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final txList = context.watch<TransactionCubit>().transactionsList;
        final goalState = context.watch<GoalCubit>().state;
        final List<GoalModel> goals = goalState is GoalLoadedState
            ? goalState.goals
            : [];

        final double totalTarget = goals.fold(
          0.0,
          (sum, goal) => sum + goal.targetAmount,
        );
        final double totalSaved = goals.fold(
          0.0,
          (sum, goal) => sum + goal.currentAmount,
        );
        final double savingsPercentage = totalTarget > 0
            ? (totalSaved / totalTarget) * 100
            : 0.0;

        final balance = userState.balance;

        final String customMessage;
        if (goals.isEmpty) {
          customMessage =
              "No savings goals created yet. Tap 'Add More' below to create a goal!";
        } else if (savingsPercentage >= 100) {
          customMessage =
              "Congratulations! You have reached 100% of your total savings target!";
        } else if (savingsPercentage == 0) {
          customMessage =
              "You haven't started saving yet. Save money towards your goals to start!";
        } else {
          customMessage =
              "You've reached ${savingsPercentage.toStringAsFixed(0)}% of your savings target. Keep up the great work!";
        }

        return Scaffold(
          appBar: const DefaultAppBar(title: "Savings"),
          body: MyBodyView(
            clipBehavior: Clip.hardEdge,
            topSection: ProgressSection(
              percentage: savingsPercentage,
              totalAmount: totalTarget,
              totalExpense: totalSaved,
              totalBalance: balance,
              rightTitle: "Total Saved",
              isRightExpense: false,
              customMessage: customMessage,
            ),
            bottomSection: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (goals.isEmpty) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "No savings goals created yet.\nTap 'Add More' below to create a goal!",
                          textAlign: TextAlign.center,
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth - 30) / 3;
                        return Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: goals.map((goal) {
                            return SizedBox(
                              width: itemWidth,
                              child: GestureDetector(
                                onLongPress: () {
                                  showAddGoalBottomSheet(context, goal: goal);
                                },
                                child: SavingsSubItem(
                                  icon: goal.iconPath,
                                  label: goal.title,
                                  onTap: () {
                                    final filtered = txList
                                        .where((tx) => tx.goalId == goal.goalId)
                                        .toList();
                                    pushTo(
                                      context,
                                      Routes.addTransactionByCategory,
                                      extra: {
                                        'categoryName': goal.title,
                                        'transactions': filtered,
                                        'goalId': goal.goalId,
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                  const Gap(40),
                  Center(
                    child: MainButton(
                      size: ButtonSize.small,
                      text: "Add More",
                      textStyle: TextStyles.bodyMedium.copyWith(
                        color: const Color(0xff093030),
                      ),
                      onPress: () {
                        showAddGoalBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
