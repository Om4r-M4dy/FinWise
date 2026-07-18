import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/search/page/search_screen.dart';

class SearchResultsList extends StatelessWidget {
  final String titleQuery;
  final String selectedCategoryKey;
  final DateTime? selectedDate;
  final TransactionType selectedTransactionType;

  const SearchResultsList({
    super.key,
    required this.titleQuery,
    required this.selectedCategoryKey,
    required this.selectedDate,
    required this.selectedTransactionType,
  });

  @override
  Widget build(BuildContext context) {
    final allTransactions =
        context.watch<TransactionCubit>().statsTransactionsList;

    final filtered = allTransactions.where((tx) {
      // 1. Filter by Title
      final query = titleQuery.trim().toLowerCase();
      if (query.isNotEmpty) {
        if (!tx.title.toLowerCase().contains(query)) {
          return false;
        }
      }

      // 2. Filter by Category
      if (selectedCategoryKey != 'all') {
        if (tx.categoryId != selectedCategoryKey) {
          return false;
        }
      }

      // 3. Filter by Date
      if (selectedDate != null) {
        if (tx.date.year != selectedDate!.year ||
            tx.date.month != selectedDate!.month ||
            tx.date.day != selectedDate!.day) {
          return false;
        }
      }

      // 4. Filter by Transaction Type (Income / Expense)
      final txType = tx.type.toLowerCase();
      if (selectedTransactionType == TransactionType.income &&
          txType != 'income') {
        return false;
      }
      if (selectedTransactionType == TransactionType.expense &&
          txType != 'expense') {
        return false;
      }

      return true;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'No matching transactions found.',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.oceanBlueButton,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const Gap(19),
      itemBuilder: (context, index) {
        final tx = filtered[index];
        final isExpense = tx.type.toLowerCase() == 'expense';

        return InfoRecord(
          bgColor: isExpense
              ? AppColors.lightBlueButton
              : AppColors.mainGreen.withValues(alpha: 0.6),
          title: tx.title,
          date: tx.formattedDate,
          cat: tx.categoryName.isNotEmpty ? tx.categoryName : 'General',
          amount: tx.getFormattedAmount(showPlusForIncome: true),
          amountColor: tx.getAmountColor(useGreenForIncome: true),
        );
      },
    );
  }
}
