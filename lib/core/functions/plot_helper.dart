import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

BarChartGroupData _buildGroup(int x, double y1, double y2) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y1,
        color: AppColors.mainGreen,
        width: 8,
        borderRadius: BorderRadius.circular(2),
      ),
      BarChartRodData(
        toY: y2,
        color: AppColors.oceanBlueButton,
        width: 8,
        borderRadius: BorderRadius.circular(2),
      ),
    ],
  );
}

List<BarChartGroupData> getCurrentChartData(int index) {
  switch (index) {
    case 0: // Day
      return [_buildGroup(0, 5000, 2000), _buildGroup(1, 3000, 8000)];
    case 1: // Week
      return [
        _buildGroup(0, 10000, 12000),
        _buildGroup(1, 15000, 5000),
        _buildGroup(2, 10000, 12000),
        _buildGroup(5, 15000, 5000),
      ];
    default:
      return [];
  }
}

double calculateMaxY(int index) {
  List<BarChartGroupData> currentData = getCurrentChartData(index);
  if (currentData.isEmpty) return 20000.0;
  double maxVal = 0;
  for (var group in currentData) {
    for (var rod in group.barRods) {
      if (rod.toY > maxVal) {
        maxVal = rod.toY;
      }
    }
  }
  return maxVal == 0 ? 20000.0 : maxVal;
}

class DynamicChartData {
  final List<BarChartGroupData> chartData;
  final List<String> labels;
  final double maxY;

  DynamicChartData({
    required this.chartData,
    required this.labels,
    required this.maxY,
  });
}

DynamicChartData getDynamicChartData(
  List<TransactionModel> transactions,
  int index,
) {
  final List<BarChartGroupData> chartData = [];
  final List<String> labels = [];
  final now = DateTime.now();

  if (index == 0) {
    // Daily: Last 7 days rolling (ending with today)
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      double income = 0.0;
      double expense = 0.0;

      for (final tx in transactions) {
        if (tx.date.isAfter(dayStart) && tx.date.isBefore(dayEnd)) {
          if (tx.type.toLowerCase() == 'income') {
            income += tx.amount;
          } else if (tx.type.toLowerCase() == 'expense') {
            expense += tx.amount;
          }
        }
      }

      final label = DateFormat('E').format(date); // Mon, Tue, etc.
      labels.add(label);
      chartData.add(_buildGroup(6 - i, income, expense));
    }
  } else if (index == 1) {
    // Weekly: Weeks of the current month
    final year = now.year;
    final month = now.month;

    final weekRanges = [
      {'start': 1, 'end': 7, 'label': '1st W'},
      {'start': 8, 'end': 14, 'label': '2nd W'},
      {'start': 15, 'end': 21, 'label': '3rd W'},
      {'start': 22, 'end': 28, 'label': '4th W'},
      {'start': 29, 'end': 31, 'label': '5th W'},
    ];

    for (int i = 0; i < weekRanges.length; i++) {
      final range = weekRanges[i];
      final startDay = range['start'] as int;
      final endDay = range['end'] as int;
      final label = range['label'] as String;

      double income = 0.0;
      double expense = 0.0;

      for (final tx in transactions) {
        if (tx.date.year == year && tx.date.month == month) {
          if (tx.date.day >= startDay && tx.date.day <= endDay) {
            if (tx.type.toLowerCase() == 'income') {
              income += tx.amount;
            } else if (tx.type.toLowerCase() == 'expense') {
              expense += tx.amount;
            }
          }
        }
      }

      labels.add(label);
      chartData.add(_buildGroup(i, income, expense));
    }
  } else {
    // Monthly: Last 6 months rolling
    for (int i = 5; i >= 0; i--) {
      int targetMonth = now.month - i;
      int targetYear = now.year;
      if (targetMonth <= 0) {
        targetMonth += 12;
        targetYear -= 1;
      }

      double income = 0.0;
      double expense = 0.0;

      for (final tx in transactions) {
        if (tx.date.year == targetYear && tx.date.month == targetMonth) {
          if (tx.type.toLowerCase() == 'income') {
            income += tx.amount;
          } else if (tx.type.toLowerCase() == 'expense') {
            expense += tx.amount;
          }
        }
      }

      final date = DateTime(targetYear, targetMonth);
      final label = DateFormat('MMM').format(date); // Jan, Feb, etc.
      labels.add(label);
      chartData.add(_buildGroup(5 - i, income, expense));
    }
  }

  double maxVal = 0.0;
  for (final group in chartData) {
    for (final rod in group.barRods) {
      if (rod.toY > maxVal) {
        maxVal = rod.toY;
      }
    }
  }
  double maxYValue = maxVal == 0 ? 1000.0 : maxVal;

  return DynamicChartData(
    chartData: chartData,
    labels: labels,
    maxY: maxYValue,
  );
}
