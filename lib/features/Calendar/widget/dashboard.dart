import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/buttons/main_button.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';
import 'package:finwise/features/Calendar/widget/categories_chart.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

enum DashboardView { spends, categories }

/// Displays a segmented dashboard for calendar details (spends vs categories).
///
/// Accepts a [selectedDay] to filter the global transaction list by date.
/// If [selectedDay] is null, today's transactions are shown.
class Dashboard extends StatefulWidget {
  final DateTime? selectedDay;

  const Dashboard({super.key, this.selectedDay});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardView _currentView = DashboardView.categories;

  List<TransactionModel> _filterTransactions(List<TransactionModel> all) {
    final day = widget.selectedDay ?? DateTime.now();
    return all.where((tx) {
      return tx.date.year == day.year &&
          tx.date.month == day.month &&
          tx.date.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allTransactions = context
        .watch<TransactionCubit>()
        .statsTransactionsList;
    final filtered = _filterTransactions(allTransactions);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MainButton(
                text: 'Spends',
                size: ButtonSize.small,
                textStyle: TextStyles.bodyMedium,
                onPress: () {
                  setState(() {
                    _currentView = DashboardView.spends;
                  });
                },
                backgroundColor: _currentView == DashboardView.spends
                    ? AppColors.mainGreen
                    : AppColors.lightGreen,
                textColor: _currentView == DashboardView.spends
                    ? AppColors.background
                    : AppColors.lettersAndIcons,
              ),
            ),
            const Gap(19),
            Expanded(
              child: MainButton(
                text: 'Categories',
                size: ButtonSize.small,
                textStyle: TextStyles.bodyMedium,
                onPress: () {
                  setState(() {
                    _currentView = DashboardView.categories;
                  });
                },
                backgroundColor: _currentView == DashboardView.categories
                    ? AppColors.mainGreen
                    : AppColors.lightGreen,
                textColor: _currentView == DashboardView.categories
                    ? AppColors.background
                    : AppColors.lettersAndIcons,
              ),
            ),
          ],
        ),

        if (_currentView == DashboardView.categories)
          CategoriesChart(transactions: filtered)
        else
          _buildSpendsList(filtered),
      ],
    );
  }

  Widget _buildSpendsList(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 56,
              color: AppColors.lettersAndIcons.withValues(alpha: 0.3),
            ),
            const Gap(12),
            Text(
              'No transactions for this day',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 35),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Gap(15),
      itemBuilder: (context, index) {
        final tx = transactions[index];
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
