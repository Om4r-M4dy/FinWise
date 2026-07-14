import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/data/repo/transaction_repo.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionStates> {
  TransactionCubit() : super(TransactionInitialState());

  List<TransactionModel> transactionsList = [];

  Future<void> getTransactions(String userId) async {
    emit(TransactionLoadingState());
    try {
      final transactionRepo = TransactionRepo();
      transactionsList = await transactionRepo.getTransactions(userId);
      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    emit(TransactionLoadingState());
    try {
      final transactionRepo = TransactionRepo();
      await transactionRepo.addTransaction(transaction);
      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    emit(TransactionLoadingState());
    try {
      final transactionRepo = TransactionRepo();
      await transactionRepo.deleteTransaction(transactionId);
      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    emit(TransactionLoadingState());
    try {
      final transactionRepo = TransactionRepo();
      await transactionRepo.updateTransaction(transaction);
      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    }
  }
}
