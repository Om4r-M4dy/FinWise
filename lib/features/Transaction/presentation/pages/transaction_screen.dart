import 'package:finwise/core/functions/calculate_budget_percentage.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/dialogs/custom_snackbar.dart';
import 'package:finwise/core/widgets/dialogs/loading_dialog.dart';
import 'package:finwise/core/widgets/icon_with_text_button.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/features/Transaction/presentation/widgets/transaction_box.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final FlipCardController flipController = FlipCardController();
  bool isIncomeSelected = false;
  bool isExpenseSelected = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final balance = userState.balance;
        final income = userState.income;
        final expense = userState.expense;
        final budget = userState.budget;
        final monthlyExpense = context.watch<TransactionCubit>().monthlyExpenses;
        final percentage = calculateBudgetPercentage(monthlyExpense, budget);

        return Scaffold(
          appBar: const DefaultAppBar(title: 'Transactions'),
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
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  height: 75,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Total Balance', style: TextStyles.bodyMedium),
                      Text(
                        '\$${balance.toStringAsFixed(2)}',
                        style: TextStyles.headlineLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(17),
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
                        });
                      },
                    ),
                    Gap(15),
                    TransactionBox(
                      titel: 'Expense',
                      balance: expense.toStringAsFixed(2),
                      pathIcon: AppAssets.expense,
                      iconColor: AppColors.oceanBlueButton,
                      balanceColor: AppColors.oceanBlueButton,
                      isSelected: isExpenseSelected,
                      onTap: () {
                        setState(() {
                          isExpenseSelected = !isExpenseSelected;
                        });
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
        )
        );
      },
    );
  }
}

class TransactionsListSection extends StatelessWidget {
  const TransactionsListSection({
    super.key,
    required this.isIncomeSelected,
    required this.isExpenseSelected,
  });

  final bool isIncomeSelected;
  final bool isExpenseSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Transactions', style: TextStyles.bodyMedium),
              IconButton(
                onPressed: () {
                  pushTo(context, Routes.calendarScreen);
                },
                icon: const CustomSvgPicture(path: AppAssets.calender),
              ),
            ],
          ),
          const Gap(20),
          BlocConsumer<TransactionCubit, TransactionStates>(
            listener: (context, state) {
              if (state is TransactionErrorState) {
                CustomSnackBar.showError(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is TransactionLoadingState) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: LoadingDialog(),
                );
              }

              if (state is TransactionErrorState) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      state.errorMessage,
                      style: TextStyles.bodyMedium,
                    ),
                  ),
                );
              }

              final cubit = context.watch<TransactionCubit>();
              final transactions = cubit.transactionsList;

              if (transactions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.mainGreen.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.receipt_long_rounded,
                            size: 40,
                            color: AppColors.mainGreen,
                          ),
                        ),
                        const Gap(16),
                        Text(
                          'No transactions yet',
                          style: TextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          'Start tracking your finances by\nadding your first transaction.',
                          textAlign: TextAlign.center,
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons.withValues(
                              alpha: 0.55,
                            ),
                            fontSize: 13,
                          ),
                        ),
                        const Gap(24),
                        IconWithTextButton(
                          icon: Icons.add_rounded,
                          text: 'Add Transaction',
                          onPress: () {
                            pushTo(context, Routes.addTransaction);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Apply selection filters
              final filteredTransactions = transactions.where((tx) {
                final isExpense = tx.type.toLowerCase() == 'expense';
                final isIncome = tx.type.toLowerCase() == 'income';

                if (isIncomeSelected && !isExpenseSelected) {
                  return isIncome;
                } else if (isExpenseSelected && !isIncomeSelected) {
                  return isExpense;
                }
                return true; // If both or neither selected, show all
              }).toList();

              if (filteredTransactions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No matching transactions found',
                          style: TextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.lettersAndIcons.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTransactions.length,
                separatorBuilder: (context, index) => const Gap(19),
                itemBuilder: (context, index) {
                  final tx = filteredTransactions[index];
                  final isExpense = tx.type.toLowerCase() == 'expense';

                  return InfoRecord(
                    transaction: tx,
                    bgColor: isExpense
                        ? AppColors.lightBlueButton
                        : AppColors.mainGreen.withValues(alpha: 0.6),
                    title: tx.title,
                    date: tx.formattedDate,
                    cat: tx.categoryName.isNotEmpty
                        ? tx.categoryName
                        : 'General',
                    amount: tx.getFormattedAmount(showPlusForIncome: true),
                    amountColor: tx.getAmountColor(useGreenForIncome: true),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
