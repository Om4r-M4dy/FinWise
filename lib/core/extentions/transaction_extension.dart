import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TransactionFormatting on TransactionModel {
  /// Formats date to: "18:27 - April 30"
  String get formattedDate {
    return DateFormat('HH:mm - MMMM dd').format(date);
  }

  /// Formats amount to: "-$100.00" for expense, "$4,000.00" or "+$4,000.00" for income
  String getFormattedAmount({bool showPlusForIncome = false}) {
    final isExpense = type.toLowerCase() == 'expense';
    final formattedValue = NumberFormat('#,##0.00').format(amount);
    final prefix = isExpense ? '-\$' : (showPlusForIncome ? '+\$' : '\$');
    return '$prefix$formattedValue';
  }

  /// ReturnsInfoRecord the corresponding color for the transaction amount
  Color? getAmountColor({bool useGreenForIncome = false}) {
    final isExpense = type.toLowerCase() == 'expense';
    if (isExpense) {
      return AppColors.oceanBlueButton;
    } else {
      return useGreenForIncome ? AppColors.mainGreen : null;
    }
  }
}
