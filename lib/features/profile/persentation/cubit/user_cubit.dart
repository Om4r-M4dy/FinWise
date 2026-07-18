import 'package:finwise/features/profile/data/models/user_model.dart';
import 'package:finwise/features/profile/persentation/cubit/user_state.dart';
import 'package:finwise/features/profile/data/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final _repository = UserRepo();

  /// Get the current UserModel if loaded
  UserModel? get user =>
      state is UserLoaded ? (state as UserLoaded).user : null;

  String? get currentUser => FirebaseAuth.instance.currentUser?.uid;

  /// Set the user directly (for instance after login/signup)
  void setUser(UserModel model) {
    emit(UserLoaded(model));
  }

  Future<void> loadUser(String uid) async {
    final result = await _repository.getUser(uid);
    result.fold(
      (_) {
        // Keep state as is on error
      },
      (model) {
        if (model != null) {
          emit(UserLoaded(model));
        }
      },
    );
  }

  /// Update financial details both locally and on Firestore
  Future<void> updateFinancials({
    double? totalBalance,
    double? totalExpense,
    double? totalIncome,
    double? monthlyBudgetLimit,
  }) async {
    if (user == null) return;

    final updated = UserModel(
      uid: user!.uid,
      username: user!.username,
      email: user!.email,
      phone: user!.phone,
      profilePicture: user!.profilePicture,
      dob: user!.dob,
      settings: user!.settings,
      totalBalance: totalBalance ?? user!.totalBalance,
      totalExpense: totalExpense ?? user!.totalExpense,
      totalIncome: totalIncome ?? user!.totalIncome,
      monthlyBudgetLimit: monthlyBudgetLimit ?? user!.monthlyBudgetLimit,
    );

    emit(UserLoaded(updated)); // optimistic UI update

    final result = await _repository.editUser(updated);
    result.fold(
      (_) {
        emit(UserLoaded(user!)); // rollback on failure
      },
      (_) {
        // Successfully updated
      },
    );
  }

  /// Update settings both locally and on Firestore
  Future<void> updateSettings({
    bool? pushNotifications,
    bool? darkTheme,
  }) async {
    if (user == null) return;

    final updatedSettings = Map<String, bool>.from(user!.settings ?? {});
    if (pushNotifications != null) {
      updatedSettings['pushNotifications'] = pushNotifications;
    }
    if (darkTheme != null) {
      updatedSettings['darkTheme'] = darkTheme;
    }

    final updated = UserModel(
      uid: user!.uid,
      username: user!.username,
      email: user!.email,
      phone: user!.phone,
      profilePicture: user!.profilePicture,
      dob: user!.dob,
      settings: updatedSettings,
      totalBalance: user!.totalBalance,
      totalExpense: user!.totalExpense,
      totalIncome: user!.totalIncome,
      monthlyBudgetLimit: user!.monthlyBudgetLimit,
    );

    emit(UserLoaded(updated)); // optimistic UI update

    final result = await _repository.editUser(updated);
    result.fold(
      (_) {
        emit(UserLoaded(user!)); // rollback on failure
      },
      (_) {
        // Successfully updated
      },
    );
  }

  /// Helper to apply a transaction to the user's totals
  Future<void> applyTransaction({
    required double amount,
    required bool isExpense,
    bool reverse = false,
  }) async {
    if (user == null) return;

    final sign = reverse ? -1 : 1;

    await updateFinancials(
      totalBalance:
          ((user!.totalBalance ?? 0) +
                  (isExpense ? -amount * sign : amount * sign))
              .clamp(0.0, double.infinity),
      totalExpense: isExpense
          ? (user!.totalExpense ?? 0) + amount * sign
          : user!.totalExpense,
      totalIncome: !isExpense
          ? (user!.totalIncome ?? 0) + amount * sign
          : user!.totalIncome,
    );
  }

  /// Clear user state on logout
  void clearUser() => emit(UserInitial());
}
