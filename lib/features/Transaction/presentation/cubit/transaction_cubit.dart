import 'package:finwise/core/constants/categories.dart';
import 'package:finwise/core/constants/transaction_type_enum.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/data/repo/transaction_repo.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/analysis/cubit/goal_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/core/services/notification/notification_service.dart';

class TransactionCubit extends Cubit<TransactionStates> {
  TransactionCubit() : super(TransactionInitialState());

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedType =
      TransactionTypeEnum.expense.value; // 'expense' or 'income'
  String selectedCategory = '8';
  String? selectedGoalId;

  void clearControllers() {
    titleController.clear();
    amountController.clear();
    noteController.clear();
    selectedDate = DateTime.now();
    selectedType = TransactionTypeEnum.expense.value;
    selectedCategory = '8';
    selectedGoalId = null;
    emit(TransactionInitialState());
  }

  void setType(String type) {
    selectedType = type;
    emit(TransactionFormUpdatedState());
  }

  void setCategory(String category) {
    selectedCategory = category;
    emit(TransactionFormUpdatedState());
  }

  void setGoalId(String? goalId) {
    selectedGoalId = goalId;
    emit(TransactionFormUpdatedState());
  }

  void setDate(DateTime date) {
    selectedDate = date;
    emit(TransactionFormUpdatedState());
  }

  List<TransactionModel> transactionsList = [];

  double get monthlyExpenses {
    final now = DateTime.now();
    return transactionsList
        .where(
          (tx) =>
              tx.type.toLowerCase() == 'expense' &&
              tx.categoryId != '2' &&
              tx.date.year == now.year &&
              tx.date.month == now.month,
        )
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get monthlyIncome {
    final now = DateTime.now();
    return transactionsList
        .where(
          (tx) =>
              tx.type.toLowerCase() == 'income' &&
              tx.date.year == now.year &&
              tx.date.month == now.month,
        )
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

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

  void populateControllers(TransactionModel transaction) {
    titleController.text = transaction.title;
    amountController.text = transaction.amount.toString();
    noteController.text = transaction.note;
    selectedDate = transaction.date;
    selectedType = transaction.type;
    selectedGoalId = transaction.goalId;

    final found = categories.firstWhere(
      (c) =>
          c['label']?.toLowerCase() == transaction.categoryName.toLowerCase(),
      orElse: () => {'key': '8'},
    );
    selectedCategory = found['key'] ?? '8';
    emit(TransactionFormUpdatedState());
  }

  Future<void> deleteTransactionWithFinancials({
    required TransactionModel transaction,
    required UserCubit userCubit,
    GoalCubit? goalCubit,
  }) async {
    emit(TransactionLoadingState());
    try {
      final transactionRepo = TransactionRepo();
      // 1. Delete from Firestore
      await transactionRepo.deleteTransaction(transaction.transactionId);

      // 2. Reverse financials
      final isExpense =
          transaction.type.toLowerCase() ==
          TransactionTypeEnum.expense.value.toLowerCase();
      await userCubit.applyTransaction(
        amount: transaction.amount,
        isExpense: isExpense,
        reverse: true,
      );

      // 3. Reverse Goal savings if linked
      if (transaction.goalId != null && goalCubit != null) {
        await goalCubit.adjustGoalAmount(
          goalId: transaction.goalId!,
          amountDiff: -transaction.amount,
          userId: transaction.userId,
        );
      }

      // 4. Refresh list
      transactionsList = await transactionRepo.getTransactions(
        transaction.userId,
      );
      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    }
  }

  Future<void> editTransaction({
    required UserCubit userCubit,
    required TransactionModel oldTransaction,
    GoalCubit? goalCubit,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(TransactionErrorState('User not authenticated.'));
      return;
    }

    final double? amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      emit(TransactionErrorState('Please enter a valid amount.'));
      return;
    }

    emit(TransactionLoadingState());

    try {
      final categoryLabel =
          categories.firstWhere(
            (c) => c['key'] == selectedCategory,
            orElse: () => {'key': '8', 'label': 'Other'},
          )['label'] ??
          'Other';

      final categoryIndex = categories.indexWhere(
        (c) => c['key'] == selectedCategory,
      );
      final categoryIdString = categoryIndex != -1
          ? categoryIndex.toString()
          : '8';

      final updatedTransaction = TransactionModel(
        transactionId: oldTransaction.transactionId,
        userId: userId,
        title: titleController.text.trim(),
        amount: amount,
        type: selectedType,
        categoryId: categoryIdString,
        categoryName: categoryLabel,
        note: noteController.text.trim(),
        date: selectedDate,
        goalId: selectedCategory == '2' ? selectedGoalId : null,
      );

      final transactionRepo = TransactionRepo();

      // 1. Update in Firestore
      await transactionRepo.updateTransaction(updatedTransaction);

      // 2. Adjust financials: reverse old first, then apply new
      final isOldExpense =
          oldTransaction.type.toLowerCase() ==
          TransactionTypeEnum.expense.value.toLowerCase();
      await userCubit.applyTransaction(
        amount: oldTransaction.amount,
        isExpense: isOldExpense,
        reverse: true,
      );
      final isNewExpense = selectedType == TransactionTypeEnum.expense.value;
      await userCubit.applyTransaction(amount: amount, isExpense: isNewExpense);

      // 3. Adjust Goal savings
      if (goalCubit != null) {
        if (oldTransaction.goalId != updatedTransaction.goalId) {
          if (oldTransaction.goalId != null) {
            await goalCubit.adjustGoalAmount(
              goalId: oldTransaction.goalId!,
              amountDiff: -oldTransaction.amount,
              userId: userId,
            );
          }
          if (updatedTransaction.goalId != null) {
            await goalCubit.adjustGoalAmount(
              goalId: updatedTransaction.goalId!,
              amountDiff: amount,
              userId: userId,
            );
          }
        } else if (updatedTransaction.goalId != null) {
          final difference = amount - oldTransaction.amount;
          if (difference != 0) {
            await goalCubit.adjustGoalAmount(
              goalId: updatedTransaction.goalId!,
              amountDiff: difference,
              userId: userId,
            );
          }
        }
      }

      // 4. Refresh list
      transactionsList = await transactionRepo.getTransactions(userId);

      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    }
  }

  Future<void> saveTransaction(
    UserCubit userCubit, {
    GoalCubit? goalCubit,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(TransactionErrorState('User not authenticated.'));
      return;
    }

    final double? amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      emit(TransactionErrorState('Please enter a valid amount.'));
      return;
    }

    emit(TransactionLoadingState());

    try {
      final transactionId = DateTime.now().millisecondsSinceEpoch.toString();

      final categoryLabel =
          categories.firstWhere(
            (c) => c['key'] == selectedCategory,
            orElse: () => {'key': '8', 'label': 'Other'},
          )['label'] ??
          'Other';

      final categoryIndex = categories.indexWhere(
        (c) => c['key'] == selectedCategory,
      );
      final categoryIdString = categoryIndex != -1
          ? categoryIndex.toString()
          : '8';

      final newTransaction = TransactionModel(
        transactionId: transactionId,
        userId: userId,
        title: titleController.text.trim(),
        amount: amount,
        type: selectedType,
        categoryId: categoryIdString,
        categoryName: categoryLabel,
        note: noteController.text.trim(),
        date: selectedDate,
        goalId: selectedCategory == '2' ? selectedGoalId : null,
      );

      final transactionRepo = TransactionRepo();

      // 1. Add transaction to Firestore
      await transactionRepo.addTransaction(newTransaction);

      // 2. Apply transaction updates to global UserCubit financials
      final isExpense = selectedType == TransactionTypeEnum.expense.value;
      await userCubit.applyTransaction(amount: amount, isExpense: isExpense);

      // 3. Update Goal savings if linked
      if (newTransaction.goalId != null && goalCubit != null) {
        await goalCubit.adjustGoalAmount(
          goalId: newTransaction.goalId!,
          amountDiff: isExpense ? amount : -amount,
          userId: userId,
        );
      }

      // 4. Add notification about this transaction
      final notificationData = {
        'title': 'Transactions',
        'subTitle': 'A new transaction has been registered',
        'iconPath': 'assets/icons/Dollar.svg',
        'date': DateTime.now(),
        'transactionDetails':
            '$categoryLabel | ${newTransaction.title} | ${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}',
        'isRead': false,
      };
      await FirestoreProvider.addNotification(userId, notificationData);

      // 4. Show instant system notification banner
      final transactionDetail =
          notificationData['transactionDetails'] as String;
      await NotificationService.showInstantNotification(
        title: 'New Transaction',
        body: transactionDetail,
      );

      // 5. Refresh transactions list
      transactionsList = await transactionRepo.getTransactions(userId);

      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    }
  }
}
