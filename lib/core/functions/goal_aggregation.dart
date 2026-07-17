import 'package:finwise/features/saving_goals/data/model/goal_model.dart';

/// Calculates the total target amount of all saving goals.
double calculateTotalGoalTarget(List<GoalModel> goals) =>
    goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);

/// Calculates the total saved amount (currentAmount) of all saving goals.
double calculateTotalGoalSaved(List<GoalModel> goals) =>
    goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);

double calculateSavingsPercentage(List<GoalModel> goals) {
  final totalTarget = calculateTotalGoalTarget(goals);
  final totalSaved = calculateTotalGoalSaved(goals);
  if (totalTarget == 0) return 0.0;
  return (totalSaved / totalTarget) * 100;
}
