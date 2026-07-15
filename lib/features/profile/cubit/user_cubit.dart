import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/auth/models/user_model.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  /// Get the current UserModel if loaded
  UserModel? get user =>
      state is UserLoaded ? (state as UserLoaded).user : null;

  String? get currentUser => FirebaseAuth.instance.currentUser?.uid;

  /// Set the user directly (for instance after login/signup)
  void setUser(UserModel model) {
    emit(UserLoaded(model));
  }

  Future<void> loadUser(String uid) async {
    try {
      final model = await FirestoreProvider.getUser(uid);
      if (model != null) {
        emit(UserLoaded(model));
      }
    } catch (_) {
      // Keep state as is on error
    }
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

    try {
      await FirestoreProvider.editUser(updated);
    } catch (_) {
      emit(UserLoaded(user!)); // rollback on failure
    }
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
          (user!.totalBalance ?? 0) +
          (isExpense ? -amount * sign : amount * sign),
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
