import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/analysis/cubit/goal_state.dart';
import 'package:finwise/features/analysis/data/model/goal_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalCubit extends Cubit<GoalState> {
  GoalCubit() : super(GoalInitialState());

  List<GoalModel> goalsList = [];

  Future<void> loadGoals(String userId) async {
    emit(GoalLoadingState());
    try {
      goalsList = await FirestoreProvider.getGoals(userId);
      emit(GoalLoadedState(goalsList));
    } catch (e) {
      emit(GoalErrorState(e.toString()));
    }
  }

  Future<void> addGoal({
    required String title,
    required double targetAmount,
    required String userId,
  }) async {
    emit(GoalLoadingState());
    try {
      final goal = GoalModel(
        goalId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        title: title,
        targetAmount: targetAmount,
        currentAmount: 0.0,
        createdAt: DateTime.now(),
      );
      await FirestoreProvider.addGoal(goal);
      await loadGoals(userId);
    } catch (e) {
      emit(GoalErrorState(e.toString()));
    }
  }

  Future<void> deleteGoal(String goalId, String userId) async {
    emit(GoalLoadingState());
    try {
      await FirestoreProvider.deleteGoal(goalId);
      await loadGoals(userId);
    } catch (e) {
      emit(GoalErrorState(e.toString()));
    }
  }

  Future<void> updateGoal({
    required String goalId,
    required String title,
    required double targetAmount,
    required double currentAmount,
    required String userId,
    required DateTime createdAt,
  }) async {
    emit(GoalLoadingState());
    try {
      final goal = GoalModel(
        goalId: goalId,
        userId: userId,
        title: title,
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        createdAt: createdAt,
      );
      await FirestoreProvider.updateGoal(goal);
      await loadGoals(userId);
    } catch (e) {
      emit(GoalErrorState(e.toString()));
    }
  }

  /// Adjusts the current amount of a specific goal.
  /// If the goal is not found in the current state/list, fetches it from Firestore.
  Future<void> adjustGoalAmount({
    required String goalId,
    required double amountDiff,
    required String userId,
  }) async {
    try {
      // Find the goal locally or fetch it
      GoalModel? targetGoal;
      for (var goal in goalsList) {
        if (goal.goalId == goalId) {
          targetGoal = goal;
          break;
        }
      }

      if (targetGoal == null) {
        // If not loaded locally, fetch user's goals first
        goalsList = await FirestoreProvider.getGoals(userId);
        for (var goal in goalsList) {
          if (goal.goalId == goalId) {
            targetGoal = goal;
            break;
          }
        }
      }

      if (targetGoal != null) {
        final updatedGoal = GoalModel(
          goalId: targetGoal.goalId,
          userId: targetGoal.userId,
          title: targetGoal.title,
          targetAmount: targetGoal.targetAmount,
          currentAmount: targetGoal.currentAmount + amountDiff,
          createdAt: targetGoal.createdAt,
        );
        await FirestoreProvider.updateGoal(updatedGoal);
        // Refresh local list
        await loadGoals(userId);
      }
    } catch (_) {
      // Fail silently to keep UX smooth
    }
  }
}
