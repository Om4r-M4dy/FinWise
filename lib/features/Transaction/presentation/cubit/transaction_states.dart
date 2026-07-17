import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

enum TimeRangeFilter { daily, weekly, monthly, lastSixMonths, customRange }

sealed class TransactionStates {}

class TransactionInitialState extends TransactionStates {}

class TransactionLoadingState extends TransactionStates {}

class TransactionLoadingMoreState extends TransactionStates {}

class TransactionSuccessState extends TransactionStates {
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> filteredTransactions;
  final bool hasReachedMax;
  final DocumentSnapshot? lastDocument;
  final String activeCategoryFilter;
  final TimeRangeFilter activeTimeFilter;
  final DateTimeRange? customDateRange;

  TransactionSuccessState({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.hasReachedMax,
    this.lastDocument,
    this.activeCategoryFilter = 'All',
    this.activeTimeFilter = TimeRangeFilter.monthly,
    this.customDateRange,
  });

  TransactionSuccessState copyWith({
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? filteredTransactions,
    bool? hasReachedMax,
    DocumentSnapshot? lastDocument,
    String? activeCategoryFilter,
    TimeRangeFilter? activeTimeFilter,
    DateTimeRange? customDateRange,
  }) {
    return TransactionSuccessState(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocument: lastDocument ?? this.lastDocument,
      activeCategoryFilter: activeCategoryFilter ?? this.activeCategoryFilter,
      activeTimeFilter: activeTimeFilter ?? this.activeTimeFilter,
      customDateRange: customDateRange ?? this.customDateRange,
    );
  }
}

class TransactionErrorState extends TransactionStates {
  final String errorMessage;

  TransactionErrorState(this.errorMessage);
}

class TransactionFormUpdatedState extends TransactionStates {}
