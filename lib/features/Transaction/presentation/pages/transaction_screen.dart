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
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/features/Transaction/presentation/widgets/transaction_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});
  final FlipCardController flipController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final user = userState is UserLoaded ? userState.user : null;
        final balance = user?.totalBalance ?? 0.0;
        final income = user?.totalIncome ?? 0.0;
        final expense = user?.totalExpense ?? 0.0;
        final budget = user?.monthlyBudgetLimit ?? 0.0;
        final percentage = budget > 0
            ? (expense / budget * 100).clamp(0.0, 100.0)
            : 0.0;

        return MyBodyView(
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
                      palance: income.toStringAsFixed(2),
                      pathIcon: AppAssets.income,
                      iconColor: AppColors.mainGreen,
                    ),
                    Gap(15),
                    TransactionBox(
                      titel: 'Expense',
                      palance: expense.toStringAsFixed(2),
                      pathIcon: AppAssets.expense,
                      iconColor: AppColors.oceanBlueButton,
                      palanceColor: AppColors.oceanBlueButton,
                    ),
                  ],
                ),
                back: ProgressSection(
                  percentage: percentage,
                  totalAmount: budget,
                  totalExpanse: expense,
                  totalBalance: balance,
                ),
              ),
            ],
          ),
          bottomSection: SingleChildScrollView(
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
                              color: AppColors.mainGreen.withValues(
                                alpha: 0.12,
                              ),
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
                              pushTo(context, Routes.addExpenses);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const Gap(19),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isExpense = tx.type.toLowerCase() == 'expense';
                    final amountPrefix = isExpense ? '-\$' : '+\$';
                    final formattedAmount =
                        '$amountPrefix${tx.amount.toStringAsFixed(2)}';

                    return InfoRecord(
                      iconPath: isExpense
                          ? AppAssets.groceries
                          : AppAssets.income,
                      bgColor: isExpense
                          ? AppColors.blueButton
                          : AppColors.lightGreen,
                      title: tx.title,
                      date: DateFormat('HH:mm - MMMM dd').format(tx.date),
                      cat: tx.categoryName.isNotEmpty
                          ? tx.categoryName
                          : 'General',
                      amount: formattedAmount,
                      amountColor: isExpense
                          ? AppColors.oceanBlueButton
                          : AppColors.mainGreen,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}
