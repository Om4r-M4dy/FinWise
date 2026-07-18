import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/percentage_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/core/functions/format_amount.dart';
import 'package:gap/gap.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({
    super.key,
    required this.percentage,
    required this.totalAmount,
    required this.totalExpense,
    required this.totalBalance,
    this.extraInfo,
    this.rightTitle,
    this.isRightExpense = true,
    this.customMessage,
  });
  final double percentage;
  final double totalAmount;
  final double totalExpense;
  final double totalBalance;
  final Widget? extraInfo;
  final String? rightTitle;
  final bool isRightExpense;
  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    final txList = context.watch<TransactionCubit>().statsTransactionsList;
    final message = customMessage ?? _getEncouragingMessage(txList, percentage);

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: TotalMoney(total: totalBalance)),
              VerticalDivider(
                color: AppColors.background,
                thickness: 1,
                width: 24,
                indent: 8,
                endIndent: 8,
              ),
              Expanded(
                child: TotalMoney(
                  total: totalExpense,
                  isExpense: isRightExpense,
                  title: rightTitle,
                ),
              ),
            ],
          ),
        ),
        const Gap(12),
        PercentageBar(percentage: percentage, totalAmount: totalAmount),
        if (extraInfo != null) ...[
          const Gap(29),
          extraInfo!,
          const Gap(22),
        ] else
          const Gap(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_box_outlined,
              color: Theme.of(context).colorScheme.onSurface,
              size: 14,
            ),
            const Gap(6),
            Expanded(child: Text(message, style: TextStyles.bodyMedium)),
          ],
        ),
      ],
    );
  }

  String _getEncouragingMessage(
    List<TransactionModel> txList,
    double percentage,
  ) {
    final now = DateTime.now();
    final expenses = txList
        .where(
          (tx) =>
              tx.type.toLowerCase() == 'expense' &&
              tx.categoryId != '2' &&
              tx.date.year == now.year &&
              tx.date.month == now.month,
        )
        .toList();
    if (expenses.isEmpty) {
      return "Great job! You haven't recorded any expenses this month.";
    }

    // Group by category and sum amounts
    final categoryTotals = <String, double>{};
    for (final tx in expenses) {
      final cat = tx.categoryName.trim().toLowerCase();
      categoryTotals[cat] = (categoryTotals[cat] ?? 0.0) + tx.amount;
    }

    if (categoryTotals.isEmpty) {
      return "Keep tracking your expenses to build healthy financial habits!";
    }

    // Find the category with the maximum total
    final topCategory = categoryTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    final topCategoryCapitalized = topCategory.isEmpty
        ? 'others'
        : '${topCategory[0].toUpperCase()}${topCategory.substring(1)}';

    if (percentage >= 100) {
      return "Oops! You've exceeded your budget limit. Try limiting your spending on $topCategoryCapitalized.";
    } else if (percentage >= 80) {
      return "Warning: You've used ${percentage.toStringAsFixed(0)}% of your budget. Watch your $topCategoryCapitalized spending.";
    } else if (percentage >= 60) {
      return "${percentage.toStringAsFixed(0)}% of your budget has been used. Take care!";
    } else if (percentage >= 40) {
      return "${percentage.toStringAsFixed(0)}% of your budget has been used. Keep it going!";
    } else if (percentage >= 20) {
      return "${percentage.toStringAsFixed(0)}% of your budget! You're on the right track!";
    }
    switch (topCategory) {
      case 'food':
        return "You're spending the most on Food. Cooking at home could help save more!";
      case 'groceries':
        return "Groceries are your top expense. Try building shopping lists to avoid impulse buys!";
      case 'transport':
        return "Transport is your top expense. Carpooling or walking could help lower this.";
      case 'entertainment':
        return "Entertainment is your top expense. Look out for free local events!";
      case 'medicine':
        return "Health is wealth! Your health expenses are well tracked.";
      case 'travel':
        return "Travel is your top expense. Keep planning ahead to catch early bird deals!";
      case 'car':
        return "Car maintenance is key, but watch out for fuel or detail budgeting!";
      case 'gift':
        return "Gifts are your top expense. Generosity is great, but budget for it!";
      case 'rent':
      case 'new house':
      case 'newhouse':
        return "Housing costs are your main expense. Keep other categories slim!";
      case 'saving':
      case 'savings':
        return "Amazing! You are prioritizing savings. Keep it up!";
      default:
        return "Your top spending category is $topCategoryCapitalized. Keep up the good work!";
    }
  }
}

class TotalMoney extends StatelessWidget {
  const TotalMoney({
    super.key,
    required this.total,
    this.isExpense = false,
    this.title,
  });
  final bool isExpense;
  final double total;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSvgPicture(
              path: isExpense ? AppAssets.expense : AppAssets.income,
              width: 12,
            ),
            const Gap(7),
            Text(
              title ?? (isExpense ? "Total Expanse" : "Total Balance"),
              style: TextStyles.bodySmall,
            ),
          ],
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            formatAmount(total, isExpense: isExpense),
            style: TextStyles.headlineLarge.copyWith(
              color: isExpense
                  ? (isDark ? AppColors.lightBlueButton : AppColors.oceanBlueButton)
                  : AppColors.background,
            ),
          ),
        ),
      ],
    );
  }
}
