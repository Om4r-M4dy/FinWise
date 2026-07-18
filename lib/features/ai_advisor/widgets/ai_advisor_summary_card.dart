import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/constants/app_colors.dart';

class AiAdvisorSummaryCard extends StatelessWidget {
  final double monthlyExpenses;
  final double budgetLimit;
  final double balance;
  final bool isDark;

  const AiAdvisorSummaryCard({
    super.key,
    required this.monthlyExpenses,
    required this.budgetLimit,
    required this.balance,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isExceeded = budgetLimit > 0 && monthlyExpenses > budgetLimit;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkGreen, AppColors.dark05]
              : [AppColors.darkGreen, AppColors.lettersAndIcons],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.query_stats_rounded,
                    color: AppColors.mainGreen,
                    size: 20,
                  ),
                  Gap(8),
                  Text(
                    'Current Month Overview',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (isExceeded)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Text(
                    'Over Budget',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Spent', '\$${monthlyExpenses.toStringAsFixed(2)}',
                  Colors.white),
              _buildMetric(
                'Budget Limit',
                budgetLimit > 0
                    ? '\$${budgetLimit.toStringAsFixed(2)}'
                    : 'Not set',
                AppColors.mainGreen,
              ),
              _buildMetric(
                  'Balance', '\$${balance.toStringAsFixed(2)}', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String title, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
