import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

String buildFinancialSummary({
  required List<TransactionModel> transactions,
  required double monthlyLimit,
  required double totalBalance,
}) {
  final now = DateTime.now();

  // Filter current month transactions
  final currentMonthTx = transactions.where((tx) {
    return tx.date.year == now.year && tx.date.month == now.month;
  }).toList();

  double totalSpent = 0.0;
  double totalIncome = 0.0;
  final Map<String, double> categoryExpenses = {};

  for (final tx in currentMonthTx) {
    final type = tx.type.toLowerCase();
    if (type == 'expense' && tx.categoryId != '2') {
      totalSpent += tx.amount;
      final category = tx.categoryName.isNotEmpty ? tx.categoryName : 'Other';
      categoryExpenses[category] = (categoryExpenses[category] ?? 0.0) + tx.amount;
    } else if (type == 'income') {
      totalIncome += tx.amount;
    }
  }

  final breakdownLines = categoryExpenses.isEmpty
      ? 'No expenses recorded this month yet.'
      : categoryExpenses.entries
          .map((e) => '  - ${e.key}: \$${e.value.toStringAsFixed(2)}')
          .join('\n');

  final remainingBudget = monthlyLimit > 0 ? monthlyLimit - totalSpent : 0.0;

  return '''
Monthly Budget Limit: \$${monthlyLimit.toStringAsFixed(2)}
Total Current Spent: \$${totalSpent.toStringAsFixed(2)}
Remaining Budget: \$${remainingBudget.toStringAsFixed(2)}
Total Monthly Income: \$${totalIncome.toStringAsFixed(2)}
Total Available Balance: \$${totalBalance.toStringAsFixed(2)}

Category Breakdown (Current Month):
$breakdownLines
''';
}
