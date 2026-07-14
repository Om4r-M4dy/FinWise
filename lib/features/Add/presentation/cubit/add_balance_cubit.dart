import 'package:finwise/features/Add/presentation/cubit/add_balance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBalanceCubit extends Cubit<AddBalanceState> {
  AddBalanceCubit() : super(AddBalanceInitial());
  final formKey = GlobalKey<FormState>();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final typeController = TextEditingController();
  final dateController = TextEditingController();
  final titelController = TextEditingController();
  final messageController = TextEditingController();

  void changeCategory(String category) {
    categoryController.text = category;
  }

  Future<void> addTransaction() async {
    try {
      if (isClosed) return;
      emit(AddBalanceLoading());
      // TODO: replace with real API/repository call
      await Future.delayed(const Duration(seconds: 1));
      if (isClosed) return;
      emit(AddBalanceSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(AddBalanceFailure(errorMessage: e.toString()));
    }
  }
}
