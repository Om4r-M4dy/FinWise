import 'package:finwise/core/functions/build_financial_summary.dart';
import 'package:finwise/core/services/gemini_service.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/ai_advisor/cubit/ai_advisor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiAdvisorCubit extends Cubit<AiAdvisorState> {
  AiAdvisorCubit() : super(AiAdvisorInitial());

  Future<void> askAdvisor({
    required List<TransactionModel> transactions,
    required double monthlyLimit,
    required double totalBalance,
    required String question,
  }) async {
    if (question.trim().isEmpty) return;

    emit(AiAdvisorLoading(question));

    try {
      final summary = buildFinancialSummary(
        transactions: transactions,
        monthlyLimit: monthlyLimit,
        totalBalance: totalBalance,
      );

      final response = await GeminiService.getFinancialAdvice(
        dataSummary: summary,
        userQuestion: question,
      );

      emit(AiAdvisorLoaded(
        question: question,
        response: response,
      ));
    } catch (e) {
      emit(AiAdvisorError(
        question: question,
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void reset() {
    emit(AiAdvisorInitial());
  }
}
