import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/category_icon_helper.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/buttons/icon_with_text_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/sections/progress_section.dart';
import 'package:finwise/features/categories/widgets/category_details.dart';
import 'package:finwise/features/Transaction/presentation/widgets/transaction_details_sheet.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_cubit.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_state.dart';
import 'package:finwise/features/saving_goals/data/model/goal_model.dart';
import 'package:finwise/core/widgets/add_goal_bottom_sheet.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/core/functions/is_category_match.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/features/profile/persentation/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TransactionsByCategoryScreen extends StatelessWidget {
  final String categoryName;
  final String? goalId;

  const TransactionsByCategoryScreen({
    super.key,
    required this.categoryName,
    this.goalId,
  });

  @override
  Widget build(BuildContext context) {
    // Watch transaction list dynamically from TransactionCubit
    final allTransactions = context
        .watch<TransactionCubit>()
        .statsTransactionsList;
    final transactions = goalId != null
        ? allTransactions.where((tx) => tx.goalId == goalId).toList()
        : allTransactions
              .where((tx) => isCategoryMatch(tx, categoryName))
              .toList();

    // Sort transactions by date descending
    final sortedTransactions = List<TransactionModel>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Grouping by Month
    final Map<String, List<TransactionModel>> grouped = {};
    for (final tx in sortedTransactions) {
      final monthName = DateFormat('MMMM').format(tx.date);
      grouped.putIfAbsent(monthName, () => []).add(tx);
    }

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final user = userState is UserLoaded ? userState.user : null;
        final budget = user?.monthlyBudgetLimit ?? 0.0;
        final balance = user?.totalBalance ?? 0.0;

        final bool isGoal = goalId != null;

        double percentage;
        double totalAmount;
        double totalExpenseValue;
        String? rightTitle;
        bool isRightExpense = true;
        String customMessage;

        if (isGoal) {
          final goalState = context.watch<GoalCubit>().state;
          final List<GoalModel> goals = goalState is GoalLoadedState
              ? goalState.goals
              : [];
          final goal = goals.firstWhere(
            (g) => g.goalId == goalId,
            orElse: () => GoalModel(
              goalId: goalId!,
              userId: '',
              title: categoryName,
              targetAmount: 0.0,
              createdAt: DateTime.now(),
            ),
          );

          totalAmount = goal.targetAmount;
          totalExpenseValue = goal.currentAmount;
          percentage = totalAmount > 0
              ? (totalExpenseValue / totalAmount) * 100
              : 0.0;
          rightTitle = "Total Saved";
          isRightExpense = false;

          if (percentage >= 100) {
            customMessage =
                "Congratulations! You have reached 100% of your target for $categoryName!";
          } else {
            customMessage =
                "You've saved \$${totalExpenseValue.toStringAsFixed(2)} of your \$${totalAmount.toStringAsFixed(2)} target for $categoryName.";
          }
        } else {
          final now = DateTime.now();
          final categorySpent = transactions
              .where(
                (tx) =>
                    tx.type.toLowerCase() == 'expense' &&
                    tx.date.year == now.year &&
                    tx.date.month == now.month,
              )
              .fold(0.0, (sum, tx) => sum + tx.amount);

          percentage = budget > 0 ? (categorySpent / budget) * 100 : 0.0;
          totalAmount = budget;
          totalExpenseValue = categorySpent;
          rightTitle = "Category Spent";
          isRightExpense = true;

          final catLower = categoryName.trim().toLowerCase();
          switch (catLower) {
            case 'food':
              customMessage =
                  "You've spent \$${categorySpent.toStringAsFixed(2)} on Food this month. Cooking at home could help save more!";
              break;
            case 'groceries':
              customMessage =
                  "You've spent \$${categorySpent.toStringAsFixed(2)} on Groceries. Try building shopping lists to avoid impulse buys!";
              break;
            case 'transport':
              customMessage =
                  "You've spent \$${categorySpent.toStringAsFixed(2)} on Transport. Carpooling or walking could help lower this.";
              break;
            case 'medicine':
              customMessage =
                  "You've spent \$${categorySpent.toStringAsFixed(2)} on medicine. Keep tracking to stay on top of your wellness!";
              break;
            case 'leisure':
            case 'entertainment':
              customMessage =
                  "You've spent \$${categorySpent.toStringAsFixed(2)} on Leisure. Watch out for impulse purchases!";
              break;
            default:
              customMessage =
                  "You have spent \$${categorySpent.toStringAsFixed(2)} on $categoryName this month.";
          }
        }

        return Scaffold(
          appBar: DefaultAppBar(
            title: categoryName,
            actions: goalId != null
                ? [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () {
                        final goalState = context.read<GoalCubit>().state;
                        if (goalState is GoalLoadedState) {
                          final goal = goalState.goals.firstWhere(
                            (g) => g.goalId == goalId,
                            orElse: () => GoalModel(
                              goalId: goalId!,
                              userId: '',
                              title: categoryName,
                              targetAmount: 0.0,
                              createdAt: DateTime.now(),
                            ),
                          );
                          showAddGoalBottomSheet(
                            context,
                            goal: goal,
                            onDeleteSuccess: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                    ),
                  ]
                : null,
          ),
          body: MyBodyView(
            clipBehavior: Clip.hardEdge,
            topSection: ProgressSection(
              percentage: percentage,
              totalAmount: totalAmount,
              totalExpense: totalExpenseValue,
              totalBalance: balance,
              rightTitle: rightTitle,
              isRightExpense: isRightExpense,
              customMessage: customMessage,
            ),
            bottomSection: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  if (sortedTransactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomSvgPicture(
                              path: AppAssets.transactions,
                              width: 200,
                              height: 200,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.05),
                            ),
                            const Gap(16),
                            Text(
                              'No transactions in this category',
                              style: TextStyles.bodyMedium.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    for (final entry in grouped.entries) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     pushTo(context, Routes.calendarScreen);
                          //   },
                          //   child: CustomSvgPicture(path: AppAssets.calender),
                          // ),
                        ],
                      ),
                      const Gap(5),
                      for (final tx in entry.value) ...[
                        CategoryDetails(
                          icon: getIconForCategory(tx.categoryName),
                          title: tx.title,
                          subtitle: tx.formattedDate,
                          trailing: tx.getFormattedAmount(
                            showPlusForIncome: true,
                          ),
                          leadingColor: tx.type.toLowerCase() == 'expense'
                              ? AppColors.blueButton
                              : AppColors.lightGreen,
                          onTap: () => showTransactionDetailsSheet(context, tx),
                        ),
                        const Gap(5),
                      ],
                      const Gap(10),
                    ],
                  const Gap(10),
                  Center(
                    child: IconWithTextButton(
                      icon: Icons.add_rounded,
                      text: 'Add Transaction',
                      onPress: () {
                        pushTo(
                          context,
                          Routes.addTransaction,
                          extra: {'category': categoryName},
                        );
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
