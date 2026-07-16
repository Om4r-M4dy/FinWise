import 'package:finwise/core/functions/get_category_id.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

bool isCategoryMatch(TransactionModel tx, String categoryName) {
  final targetId = getCategoryId(categoryName);
  final txCatName = tx.categoryName.toLowerCase().trim();
  final targetName = categoryName.toLowerCase().trim();
  return tx.categoryId == targetId || txCatName == targetName;
}
