import 'package:finwise/core/services/remote/firebase_provider.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

class TransactionRepo {
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await FirebaseProvider.addTransaction(transaction);
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionModel> getTransaction(String transactionId) async {
    try {
      return await FirebaseProvider.getTransaction(transactionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      return await FirebaseProvider.getTransactions(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await FirebaseProvider.deleteTransaction(transactionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await FirebaseProvider.updateTransaction(transaction);
    } catch (e) {
      rethrow;
    }
  }
}
