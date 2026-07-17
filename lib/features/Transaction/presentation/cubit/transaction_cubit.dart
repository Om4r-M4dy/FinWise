import 'package:finwise/core/constants/categories.dart';
import 'package:finwise/core/constants/transaction_type_enum.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/data/repo/transaction_repo.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:finwise/core/errors/failures.dart';

import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/core/services/notification/notification_service.dart';

class TransactionCubit extends Cubit<TransactionStates> {
  TransactionCubit() : super(TransactionInitialState());

  final _repository = TransactionRepo();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedType =
      TransactionTypeEnum.expense.value; // 'expense' or 'income'
  String selectedCategory = '8';
  String? selectedGoalId;

  void setType(String type) {
    selectedType = type;
    emit(TransactionFormUpdatedState());
  }

  void setCategory(String categoryKey) {
    selectedCategory = categoryKey;
    if (selectedCategory != '2') {
      selectedGoalId = null;
    }
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

  // Dual-dataset states:
  // transactionsList: For scrollable pagination history.
  // statsTransactionsList: Locally cached last 6 months for real-time charts/metrics.
  List<TransactionModel> transactionsList = [];
  List<TransactionModel> statsTransactionsList = [];

  final int _pageSize = 20;
  bool _isFetchingPage = false;

  bool get isLoadingMore => _isFetchingPage;

  bool get hasMore {
    final currentState = state;
    if (currentState is TransactionSuccessState) {
      return !currentState.hasReachedMax;
    }
    return false;
  }

  List<TransactionModel> _applyFiltersLocally({
    required List<TransactionModel> transactions,
    required TimeRangeFilter timeFilter,
    required String category,
    DateTimeRange? customRange,
  }) {
    final now = DateTime.now();
    return transactions.where((tx) {
      // 1. Filter by transaction type
      if (category == 'income') {
        if (tx.type.toLowerCase() != 'income') return false;
      } else if (category == 'expense') {
        if (tx.type.toLowerCase() != 'expense') return false;
      } else if (category != 'All') {
        // filter by exact category name matching
        if (tx.categoryName.toLowerCase() != category.toLowerCase())
          return false;
      }

      // 2. Filter by time range
      switch (timeFilter) {
        case TimeRangeFilter.daily:
          final today = DateTime(now.year, now.month, now.day);
          return tx.date.isAfter(today) || tx.date.isAtSameMomentAs(today);
        case TimeRangeFilter.weekly:
          final oneWeekAgo = now.subtract(const Duration(days: 7));
          return tx.date.isAfter(oneWeekAgo);
        case TimeRangeFilter.monthly:
          final firstDayOfMonth = DateTime(now.year, now.month, 1);
          return tx.date.isAfter(firstDayOfMonth) ||
              tx.date.isAtSameMomentAs(firstDayOfMonth);
        case TimeRangeFilter.lastSixMonths:
          final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);
          return tx.date.isAfter(sixMonthsAgo) ||
              tx.date.isAtSameMomentAs(sixMonthsAgo);
        case TimeRangeFilter.customRange:
          if (customRange != null) {
            final start = DateTime(
              customRange.start.year,
              customRange.start.month,
              customRange.start.day,
            );
            final end = DateTime(
              customRange.end.year,
              customRange.end.month,
              customRange.end.day,
              23,
              59,
              59,
            );
            return (tx.date.isAfter(start) ||
                    tx.date.isAtSameMomentAs(start)) &&
                (tx.date.isBefore(end) || tx.date.isAtSameMomentAs(end));
          }
          return true;
      }
    }).toList();
  }

  double get monthlyExpenses {
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

  /// Initial fetch of transactions for both stats (6 months) and history page (first page).
  Future<void> getTransactions(String userId, {bool silent = false}) async {
    if (!silent) {
      emit(TransactionLoadingState());
    }
    _isFetchingPage = true;
    try {
      // 1. Fetch last 6 months of transactions for charts/statistics caching.
      final now = DateTime.now();
      final startOfPeriod = DateTime(now.year, now.month - 5, 1);
      final statsResult = await _repository.fetchTransactionsByDateRange(
        userId,
        startDate: startOfPeriod,
        endDate: now,
      );

      // 2. Fetch first page of general transactions history.
      final pageResult = await _repository.fetchTransactionsPage(
        userId,
        limit: _pageSize,
        startAfter: null,
        filterType: null,
      );

      Failure? failure;
      List<TransactionModel> stats = [];
      PaginatedTransactionsResult? page;

      statsResult.fold((f) => failure = f, (s) => stats = s);
      pageResult.fold((f) => failure = f, (p) => page = p);

      if (failure != null) {
        emit(TransactionErrorState(failure!.message));
        _isFetchingPage = false;
        return;
      }

      statsTransactionsList = stats;
      transactionsList = page!.transactions;

      final success = TransactionSuccessState(
        allTransactions: page!.transactions,
        filteredTransactions: _applyFiltersLocally(
          transactions: page!.transactions,
          timeFilter: TimeRangeFilter.monthly,
          category: 'All',
        ),
        hasReachedMax: page!.hasReachedMax,
        lastDocument: page!.lastDocument,
        activeTimeFilter: TimeRangeFilter.monthly,
        activeCategoryFilter: 'All',
      );
      emit(success);
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    } finally {
      _isFetchingPage = false;
    }
  }

  /// Appends the next page of transactions for history infinite scrolling.
  Future<void> loadMoreTransactions(String userId) async {
    final currentState = state;
    if (currentState is! TransactionSuccessState ||
        currentState.hasReachedMax ||
        _isFetchingPage) {
      return;
    }

    _isFetchingPage = true;
    emit(TransactionLoadingMoreState());

    try {
      final filterType = currentState.activeCategoryFilter == 'All'
          ? null
          : currentState.activeCategoryFilter;

      final resultEither = await _repository.fetchTransactionsPage(
        userId,
        limit: _pageSize,
        startAfter: currentState.lastDocument,
        filterType: filterType,
      );

      resultEither.fold(
        (failure) {
          emit(TransactionErrorState(failure.message));
          emit(currentState);
        },
        (result) {
          // Deduplicate elements to guarantee uniqueness.
          final uniqueNew = result.transactions
              .where(
                (newTx) => !currentState.allTransactions.any(
                  (oldTx) => oldTx.transactionId == newTx.transactionId,
                ),
              )
              .toList();

          final updatedAll = List<TransactionModel>.from(
            currentState.allTransactions,
          )..addAll(uniqueNew);
          transactionsList = updatedAll;

          final success = currentState.copyWith(
            allTransactions: updatedAll,
            filteredTransactions: _applyFiltersLocally(
              transactions: updatedAll,
              timeFilter: currentState.activeTimeFilter,
              category: currentState.activeCategoryFilter,
              customRange: currentState.customDateRange,
            ),
            hasReachedMax: result.hasReachedMax,
            lastDocument: result.lastDocument,
          );

          emit(success);
        },
      );
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
      emit(currentState);
    } finally {
      _isFetchingPage = false;
    }
  }

  /// Changes the root UI type filter (income vs expense vs all).
  Future<void> changeFilter(String userId, String? filterType) async {
    emit(TransactionLoadingState());
    _isFetchingPage = true;
    try {
      final resultEither = await _repository.fetchTransactionsPage(
        userId,
        limit: _pageSize,
        startAfter: null,
        filterType: filterType,
      );

      resultEither.fold(
        (failure) {
          emit(TransactionErrorState(failure.message));
        },
        (result) {
          transactionsList = result.transactions;

          final success = TransactionSuccessState(
            allTransactions: result.transactions,
            filteredTransactions: _applyFiltersLocally(
              transactions: result.transactions,
              timeFilter: TimeRangeFilter.monthly,
              category: filterType ?? 'All',
            ),
            hasReachedMax: result.hasReachedMax,
            lastDocument: result.lastDocument,
            activeTimeFilter: TimeRangeFilter.monthly,
            activeCategoryFilter: filterType ?? 'All',
          );

          emit(success);
        },
      );
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    } finally {
      _isFetchingPage = false;
    }
  }

  /// Intelligent filtering that leverages local cache or queries on-demand.
  Future<void> updateFilters(
    String userId, {
    required TimeRangeFilter timeFilter,
    required String categoryFilter,
    DateTimeRange? customRange,
  }) async {
    final currentState = state;
    if (currentState is! TransactionSuccessState) return;

    final now = DateTime.now();
    bool requiresRemoteFetch = false;

    if (timeFilter == TimeRangeFilter.lastSixMonths) {
      requiresRemoteFetch = true;
    } else if (timeFilter == TimeRangeFilter.customRange &&
        customRange != null) {
      final oldestInMemoryDate = currentState.allTransactions.isEmpty
          ? now
          : currentState.allTransactions.last.date;
      if (customRange.start.isBefore(oldestInMemoryDate)) {
        requiresRemoteFetch = true;
      }
    }

    if (requiresRemoteFetch) {
      emit(TransactionLoadingState());
      _isFetchingPage = true;
      try {
        DateTime startBoundary = now;
        if (timeFilter == TimeRangeFilter.lastSixMonths) {
          startBoundary = DateTime(now.year, now.month - 5, 1);
        } else if (customRange != null) {
          startBoundary = customRange.start;
        }

        final remoteTxsEither = await _repository.fetchTransactionsByDateRange(
          userId,
          startDate: startBoundary,
          endDate: customRange?.end ?? now,
        );

        remoteTxsEither.fold(
          (failure) {
            emit(TransactionErrorState(failure.message));
            emit(currentState);
          },
          (remoteTxs) {
            transactionsList = remoteTxs;

            emit(
              TransactionSuccessState(
                allTransactions: remoteTxs,
                filteredTransactions: _applyFiltersLocally(
                  transactions: remoteTxs,
                  timeFilter: timeFilter,
                  category: categoryFilter,
                  customRange: customRange,
                ),
                hasReachedMax: true, // Complete custom boundary query.
                lastDocument: null,
                activeTimeFilter: timeFilter,
                activeCategoryFilter: categoryFilter,
                customDateRange: customRange,
              ),
            );
          },
        );
      } catch (e) {
        emit(TransactionErrorState(e.toString()));
        emit(currentState);
      } finally {
        _isFetchingPage = false;
      }
    } else {
      // Local dynamic filter application
      emit(
        currentState.copyWith(
          filteredTransactions: _applyFiltersLocally(
            transactions: currentState.allTransactions,
            timeFilter: timeFilter,
            category: categoryFilter,
            customRange: customRange,
          ),
          activeTimeFilter: timeFilter,
          activeCategoryFilter: categoryFilter,
          customDateRange: customRange,
        ),
      );
    }
  }

  void clearControllers() {
    titleController.clear();
    amountController.clear();
    noteController.clear();
    selectedDate = DateTime.now();
    selectedCategory = '8';
    selectedType = TransactionTypeEnum.expense.value;
    selectedGoalId = null;
  }

  void populateControllers(TransactionModel transaction) {
    titleController.text = transaction.title;
    amountController.text = transaction.amount.toString();
    noteController.text = transaction.note;
    selectedDate = transaction.date;
    selectedType = transaction.type.toLowerCase() ==
            TransactionTypeEnum.expense.value.toLowerCase()
        ? TransactionTypeEnum.expense.value
        : TransactionTypeEnum.income.value;
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
      final deleteEither = await _repository.deleteTransaction(
        transaction.transactionId,
      );

      await deleteEither.fold(
        (failure) async {
          emit(TransactionErrorState(failure.message));
        },
        (_) async {
          final isExpense =
              transaction.type.toLowerCase() ==
              TransactionTypeEnum.expense.value.toLowerCase();
          await userCubit.applyTransaction(
            amount: transaction.amount,
            isExpense: isExpense,
            reverse: true,
          );

          if (transaction.goalId != null && goalCubit != null) {
            await goalCubit.adjustGoalAmount(
              goalId: transaction.goalId!,
              amountDiff: -transaction.amount,
              userId: transaction.userId,
            );
          }

          await getTransactions(transaction.userId, silent: true);
        },
      );
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

      final updateEither = await _repository.updateTransaction(
        updatedTransaction,
      );

      await updateEither.fold(
        (failure) async {
          emit(TransactionErrorState(failure.message));
        },
        (_) async {
          final isOldExpense =
              oldTransaction.type.toLowerCase() ==
              TransactionTypeEnum.expense.value.toLowerCase();
          await userCubit.applyTransaction(
            amount: oldTransaction.amount,
            isExpense: isOldExpense,
            reverse: true,
          );
          final isNewExpense =
              selectedType == TransactionTypeEnum.expense.value;
          await userCubit.applyTransaction(
            amount: amount,
            isExpense: isNewExpense,
          );

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

          await getTransactions(userId, silent: true);
        },
      );
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

      final addEither = await _repository.addTransaction(newTransaction);

      await addEither.fold(
        (failure) async {
          emit(TransactionErrorState(failure.message));
        },
        (_) async {
          final isExpense = selectedType == TransactionTypeEnum.expense.value;
          await userCubit.applyTransaction(
            amount: amount,
            isExpense: isExpense,
          );

          if (newTransaction.goalId != null && goalCubit != null) {
            await goalCubit.adjustGoalAmount(
              goalId: newTransaction.goalId!,
              amountDiff: isExpense ? amount : -amount,
              userId: userId,
            );
          }

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

          final showPush =
              userCubit.user?.settings?['pushNotifications'] ?? true;
          if (showPush) {
            final transactionDetail =
                notificationData['transactionDetails'] as String;
            await NotificationService.showInstantNotification(
              title: 'New Transaction',
              body: transactionDetail,
            );
          }

          await getTransactions(userId, silent: true);
        },
      );
    } catch (e) {
      emit(TransactionErrorState(e.toString()));
    }
  }
}
