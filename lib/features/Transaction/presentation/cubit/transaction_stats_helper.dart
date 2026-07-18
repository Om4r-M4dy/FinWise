import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

class TransactionStatsHelper {
  static double calculateMonthlyExpenses(List<TransactionModel> statsTransactionsList) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    return statsTransactionsList
        .where(
          (tx) =>
              tx.type.toLowerCase() == 'expense' &&
              (tx.date.isAfter(firstDayOfMonth) ||
                  tx.date.isAtSameMomentAs(firstDayOfMonth)),
        )
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }
}
