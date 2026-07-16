import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

Map<String, dynamic> calculateLastWeekAnalysis({
  required List<TransactionModel> transactions,
  required double totalIncome,
  required double totalExpense,
}) {
  final now = DateTime.now();
  final sevenDaysAgo = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(const Duration(days: 6));

  double revenueLastWeek = 0.0;
  double expensesLastWeek = 0.0;

  for (final tx in transactions) {
    final isWithinLastWeek =
        tx.date.isAfter(sevenDaysAgo) ||
        (tx.date.year == sevenDaysAgo.year &&
            tx.date.month == sevenDaysAgo.month &&
            tx.date.day == sevenDaysAgo.day);

    if (isWithinLastWeek) {
      if (tx.type.toLowerCase() == 'income') {
        revenueLastWeek += tx.amount;
      } else if (tx.type.toLowerCase() == 'expense') {
        expensesLastWeek += tx.amount;
      }
    }
  }

  final totalSavings = transactions
      .where((tx) => tx.type.toLowerCase() == 'expense' && tx.categoryId == '2')
      .fold(0.0, (sum, tx) => sum + tx.amount);

  final adjustedExpense = (totalExpense - totalSavings).clamp(0.0, double.infinity);

  double savingsPercent = 0.0;
  if (totalIncome > 0) {
    savingsPercent = ((totalIncome - adjustedExpense) / totalIncome * 100).clamp(
      0.0,
      100.0,
    );
  }

  return {
    'revenue': revenueLastWeek,
    'expenses': expensesLastWeek,
    'savingsPercent': savingsPercent,
  };
}
