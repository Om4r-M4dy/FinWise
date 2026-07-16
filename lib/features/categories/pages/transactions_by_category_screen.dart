import 'package:finwise/core/functions/calculate_budget_percentage.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/category_icon_helper.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/icon_with_text_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/categories/widgets/category_details.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/core/functions/get_category_id.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TransactionsByCategoryScreen extends StatelessWidget {
  final String categoryName;

  const TransactionsByCategoryScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    // Watch transaction list dynamically from TransactionCubit
    final allTransactions = context.watch<TransactionCubit>().transactionsList;
    final transactions = allTransactions
        .where((tx) => _isCategoryMatch(tx, categoryName))
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
        final expense = user?.totalExpense ?? 0.0;
        final balance = user?.totalBalance ?? 0.0;
        final monthlyExpense = context.watch<TransactionCubit>().monthlyExpenses;
        final percentage = calculateBudgetPercentage(monthlyExpense, budget);

        return Scaffold(
          appBar: DefaultAppBar(title: categoryName),
          body: MyBodyView(
            clipBehavior: Clip.hardEdge,
            topSection: ProgressSection(
              percentage: percentage,
              totalAmount: budget,
              totalExpense: expense,
              totalBalance: balance,
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
                              color: AppColors.gray39.withValues(alpha: 0.05),
                            ),
                            const Gap(16),
                            Text(
                              'No transactions in this category',
                              style: TextStyles.bodyMedium.copyWith(
                                color: AppColors.gray39.withValues(alpha: 0.5),
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
                              color: AppColors.lettersAndIcons,
                            ),
                          ),
                          CustomSvgPicture(path: AppAssets.calender),
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

bool _isCategoryMatch(TransactionModel tx, String categoryName) {
  final targetId = getCategoryId(categoryName);
  final txCatName = tx.categoryName.toLowerCase().trim();
  final targetName = categoryName.toLowerCase().trim();
  return tx.categoryId == targetId || txCatName == targetName;
}
