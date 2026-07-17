import 'package:finwise/features/saving_goals/data/model/goal_model.dart';

abstract class GoalState {}

class GoalInitialState extends GoalState {}

class GoalLoadingState extends GoalState {}

class GoalLoadedState extends GoalState {
  final List<GoalModel> goals;
  GoalLoadedState(this.goals);
}

class GoalErrorState extends GoalState {
  final String errorMessage;
  GoalErrorState(this.errorMessage);
}
