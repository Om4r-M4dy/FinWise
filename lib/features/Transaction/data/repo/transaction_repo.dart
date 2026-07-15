import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

class TransactionRepo {
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await FirestoreProvider.addTransaction(transaction);
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionModel> getTransaction(String transactionId) async {
    try {
      return await FirestoreProvider.getTransaction(transactionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      return await FirestoreProvider.getTransactions(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await FirestoreProvider.deleteTransaction(transactionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await FirestoreProvider.updateTransaction(transaction);
    } catch (e) {
      rethrow;
    }
  }
}
