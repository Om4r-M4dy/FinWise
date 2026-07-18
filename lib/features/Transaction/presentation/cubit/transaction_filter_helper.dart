import 'package:flutter/material.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';

class TransactionFilterHelper {
  static List<TransactionModel> applyFiltersLocally({
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
        if (tx.categoryName.toLowerCase() != category.toLowerCase()) {
          return false;
        }
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
}
