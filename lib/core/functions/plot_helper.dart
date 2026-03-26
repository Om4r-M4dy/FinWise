  import 'package:finwise/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

int index = 0;

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
        return [_buildGroup(0, 5, 2), _buildGroup(1, 3, 8)];
      case 1: // Week
        return [
          _buildGroup(0, 10, 12),
          _buildGroup(1, 15, 5),
          _buildGroup(2, 10, 12),
          _buildGroup(5, 15, 5),
        ];
      default:
        return [];
    }
  }

  double calculateMaxY(int index) {
    List<BarChartGroupData> currentData = getCurrentChartData(index);
    if (currentData.isEmpty) return 20.0;
    double maxVal = 0;
    for (var group in currentData) {
      for (var rod in group.barRods) {
        if (rod.toY > maxVal) {
          maxVal = rod.toY;
        }
      }
    }
    return maxVal == 0 ? 20.0 : maxVal * 1.2;
  }
