import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/goal_aggregation.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/buttons/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/sections/progress_section.dart';
import 'package:finwise/core/widgets/add_goal_bottom_sheet.dart';
import 'package:finwise/features/saving_goals/persentation/widget/savings_sub_item.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/core/widgets/dialogs/custom_snackbar.dart';
import 'package:finwise/core/extentions/dialogs.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/features/profile/persentation/cubit/user_state.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_cubit.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_state.dart';
import 'package:finwise/features/saving_goals/data/model/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class Savings extends StatefulWidget {
  const Savings({super.key});

  @override
  State<Savings> createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {
  bool _isInitialLoad = true;
  bool _isLoadingDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoalCubit, GoalState>(
      listener: (context, goalState) {
        if (goalState is GoalLoadingState) {
          if (!_isInitialLoad && !_isLoadingDialogShowing) {
            _isLoadingDialogShowing = true;
            showLoadingDialog(context);
          }
        } else if (goalState is GoalLoadedState) {
          _isInitialLoad = false;
          if (_isLoadingDialogShowing) {
            _isLoadingDialogShowing = false;
            pop(context);
          }
        } else if (goalState is GoalErrorState) {
          if (_isLoadingDialogShowing) {
            _isLoadingDialogShowing = false;
            pop(context);
          }
          CustomSnackBar.showError(context, goalState.errorMessage);
        }
      },
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          final txList = context
              .watch<TransactionCubit>()
              .statsTransactionsList;
          final goalState = context.watch<GoalCubit>().state;
          final List<GoalModel> goals = goalState is GoalLoadedState
              ? goalState.goals
              : [];

          final double totalTarget = calculateTotalGoalTarget(goals);
          final double totalSaved = calculateTotalGoalSaved(goals);

          final double savingsPercentage = calculateSavingsPercentage(goals);

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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomSvgPicture(
                                path: AppAssets.saving,
                                width: 60,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              Gap(15),
                              Text(
                                "No savings goals created yet.\nTap 'Add More' below to create a goal!",
                                textAlign: TextAlign.center,
                                style: TextStyles.bodyMedium.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .color!
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
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
                                          .where(
                                            (tx) => tx.goalId == goal.goalId,
                                          )
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
      ),
    );
  }
}
