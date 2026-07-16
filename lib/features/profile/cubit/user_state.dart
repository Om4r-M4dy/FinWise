import 'package:finwise/features/auth/models/user_model.dart';
import 'package:finwise/core/services/local/user_prefs.dart';

import 'package:finwise/core/functions/calculate_budget_percentage.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

extension UserStateExtension on UserState {
  UserModel? get user {
    final state = this;
    if (state is UserLoaded) return state.user;
    return null;
  }

  double get budget => user?.monthlyBudgetLimit ?? 0.0;
  double get expense => user?.totalExpense ?? 0.0;
  double get balance => user?.totalBalance ?? 0.0;
  double get income => user?.totalIncome ?? 0.0;

  double get budgetPercentage {
    return calculateBudgetPercentage(expense, budget);
  }

  String get userName {
    final name = user?.username;
    if (name != null && name.isNotEmpty) return name;
    return UserPrefs.getName() ?? "there";
  }
}
