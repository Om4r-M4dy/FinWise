import 'package:finwise/features/saving_goals/persentation/cubit/goal_state.dart';
import 'package:finwise/features/saving_goals/data/model/goal_model.dart';
import 'package:finwise/features/saving_goals/data/repo/goal_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalCubit extends Cubit<GoalState> {
  GoalCubit() : super(GoalInitialState());

  final _repository = GoalRepo();
  List<GoalModel> goalsList = [];

  Future<void> loadGoals(String userId) async {
    emit(GoalLoadingState());
    final result = await _repository.getGoals(userId);

    result.fold(
      (failure) {
        emit(GoalErrorState(failure.message));
      },
      (goals) {
        goalsList = goals;
        emit(GoalLoadedState(goalsList));
      },
    );
  }

  Future<void> addGoal({
    required String title,
    required double targetAmount,
    required String userId,
  }) async {
    if (goalsList.length >= 5) {
      emit(
        GoalErrorState(
          "You can only have up to 5 savings goals to avoid overwhelming yourself.",
        ),
      );
      return;
    }
    emit(GoalLoadingState());

    final goal = GoalModel(
      goalId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: title,
      targetAmount: targetAmount,
      currentAmount: 0.0,
      createdAt: DateTime.now(),
    );

    final result = await _repository.addGoal(goal);

    await result.fold(
      (failure) async {
        emit(GoalErrorState(failure.message));
      },
      (_) async {
        await loadGoals(userId);
      },
    );
  }

  Future<void> deleteGoal(String goalId, String userId) async {
    emit(GoalLoadingState());
    final result = await _repository.deleteGoal(goalId);

    await result.fold(
      (failure) async {
        emit(GoalErrorState(failure.message));
      },
      (_) async {
        await loadGoals(userId);
      },
    );
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

    final goal = GoalModel(
      goalId: goalId,
      userId: userId,
      title: title,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      createdAt: createdAt,
    );

    final result = await _repository.updateGoal(goal);

    await result.fold(
      (failure) async {
        emit(GoalErrorState(failure.message));
      },
      (_) async {
        await loadGoals(userId);
      },
    );
  }

  /// Adjusts the current amount of a specific goal.
  /// If the goal is not found in the current state/list, fetches it from Firestore.
  Future<void> adjustGoalAmount({
    required String goalId,
    required double amountDiff,
    required String userId,
  }) async {
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
      final getResult = await _repository.getGoals(userId);
      getResult.fold((_) {}, (goals) {
        goalsList = goals;
        for (var goal in goalsList) {
          if (goal.goalId == goalId) {
            targetGoal = goal;
            break;
          }
        }
      });
    }

    if (targetGoal != null) {
      final updatedGoal = GoalModel(
        goalId: targetGoal!.goalId,
        userId: targetGoal!.userId,
        title: targetGoal!.title,
        targetAmount: targetGoal!.targetAmount,
        currentAmount: targetGoal!.currentAmount + amountDiff,
        createdAt: targetGoal!.createdAt,
      );
      final updateResult = await _repository.updateGoal(updatedGoal);
      await updateResult.fold((_) async {}, (_) async {
        // Refresh local list
        await loadGoals(userId);
      });
    }
  }
}
