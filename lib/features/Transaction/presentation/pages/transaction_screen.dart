import 'package:finwise/core/functions/calculate_budget_percentage.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/sections/progress_section.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/widgets/transaction_box.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/features/profile/persentation/cubit/user_state.dart';
import 'package:finwise/core/widgets/export_filter_bottom_sheet.dart';

import 'package:finwise/features/Transaction/presentation/widgets/transactions_list_section.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final FlipCardController flipController = FlipCardController();
  bool isIncomeSelected = false;
  bool isExpenseSelected = false;

  void _updateFilter() {
    final userId = context.read<UserCubit>().currentUser;
    if (userId != null) {
      String? filter;
      if (isIncomeSelected && !isExpenseSelected) {
        filter = 'income';
      } else if (isExpenseSelected && !isIncomeSelected) {
        filter = 'expense';
      }
      context.read<TransactionCubit>().changeFilter(userId, filter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final balance = userState.balance;
        final income = userState.income;
        final expense = userState.expense;
        final budget = userState.budget;
        final monthlyExpense = context
            .watch<TransactionCubit>()
            .monthlyExpenses;
        final percentage = calculateBudgetPercentage(monthlyExpense, budget);

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: DefaultAppBar(
            title: 'Transactions',
            actions: [
              IconButton(
                tooltip: 'Export to CSV',
                onPressed: () {
                  final transactions = context
                      .read<TransactionCubit>()
                      .transactionsList;
                  showExportFilterBottomSheet(context, transactions);
                },
                icon: const Icon(Icons.ios_share_rounded),
              ),
            ],
          ),
          body: MyBodyView(
            clipBehavior: Clip.hardEdge,
            noPadding: true,
            topSection: Column(
              children: [
                InkWell(
                  onTap: () {
                    flipController.toggleCard();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkGreen.withValues(alpha: 0.7)
                          : AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    height: 75,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyles.bodyMedium.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppColors.lettersAndIcons,
                          ),
                        ),
                        Text(
                          '\$${balance.toStringAsFixed(2)}',
                          style: TextStyles.headlineLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : AppColors.lettersAndIcons,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(17),
                FlipCard(
                  controller: flipController,
                  flipOnTouch: false,
                  front: Row(
                    children: [
                      TransactionBox(
                        titel: 'Incom',
                        balance: income.toStringAsFixed(2),
                        pathIcon: AppAssets.income,
                        iconColor: AppColors.mainGreen,
                        isSelected: isIncomeSelected,
                        onTap: () {
                          setState(() {
                            isIncomeSelected = !isIncomeSelected;
                            if (isIncomeSelected) {
                              isExpenseSelected = false;
                            }
                          });
                          _updateFilter();
                        },
                      ),
                      const Gap(15),
                      TransactionBox(
                        titel: 'Expense',
                        balance: expense.toStringAsFixed(2),
                        pathIcon: AppAssets.expense,
                        iconColor: isDark
                            ? AppColors.lightBlueButton
                            : AppColors.oceanBlueButton,
                        balanceColor: isDark
                            ? AppColors.lightBlueButton
                            : AppColors.oceanBlueButton,
                        isSelected: isExpenseSelected,
                        onTap: () {
                          setState(() {
                            isExpenseSelected = !isExpenseSelected;
                            if (isExpenseSelected) {
                              isIncomeSelected = false;
                            }
                          });
                          _updateFilter();
                        },
                      ),
                    ],
                  ),
                  back: ProgressSection(
                    percentage: percentage,
                    totalAmount: budget,
                    totalExpense: expense,
                    totalBalance: balance,
                  ),
                ),
              ],
            ),
            bottomSection: TransactionsListSection(
              isIncomeSelected: isIncomeSelected,
              isExpenseSelected: isExpenseSelected,
            ),
          ),
        );
      },
    );
  }
}
