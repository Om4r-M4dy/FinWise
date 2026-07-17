import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

class PaginatedTransactionsResult {
  final List<TransactionModel> transactions;
  final DocumentSnapshot? lastDocument;
  final bool hasReachedMax;

  const PaginatedTransactionsResult({
    required this.transactions,
    required this.lastDocument,
    required this.hasReachedMax,
  });
}

class TransactionRepo {
  Future<Either<Failure, void>> addTransaction(TransactionModel transaction) async {
    if (!await hasInternetConnection()) {
      return const Left(NetworkFailure());
    }
    try {
      await FirestoreProvider.addTransaction(transaction);
      return const Right(null);
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, PaginatedTransactionsResult>> fetchTransactionsPage(
    String userId, {
    required int limit,
    DocumentSnapshot? startAfter,
    String? filterType,
  }) async {
    try {
      final snapshot = await FirestoreProvider.getTransactionsPage(
        userId,
        limit: limit,
        startAfterDoc: startAfter,
        filterType: filterType,
      );

      final List<TransactionModel> transactions = snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      final hasReachedMax = transactions.length < limit;

      return Right(PaginatedTransactionsResult(
        transactions: transactions,
        lastDocument: lastDoc,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, List<TransactionModel>>> fetchTransactionsByDateRange(
    String userId, {
    required DateTime startDate,
    required DateTime endDate,
    int? limit,
  }) async {
    try {
      final list = await FirestoreProvider.getTransactionsForRange(userId, startDate, endDate);
      if (limit != null && list.length > limit) {
        return Right(list.sublist(0, limit));
      }
      return Right(list);
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> deleteTransaction(String transactionId) async {
    if (!await hasInternetConnection()) {
      return const Left(NetworkFailure());
    }
    try {
      await FirestoreProvider.deleteTransaction(transactionId);
      return const Right(null);
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, void>> updateTransaction(TransactionModel transaction) async {
    if (!await hasInternetConnection()) {
      return const Left(NetworkFailure());
    }
    try {
      await FirestoreProvider.updateTransaction(transaction);
      return const Right(null);
    } catch (e) {
      return Left(mapException(e));
    }
  }
}
