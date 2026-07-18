abstract class AiAdvisorState {}

class AiAdvisorInitial extends AiAdvisorState {}

class AiAdvisorLoading extends AiAdvisorState {
  final String question;
  AiAdvisorLoading(this.question);
}

class AiAdvisorLoaded extends AiAdvisorState {
  final String question;
  final String response;

  AiAdvisorLoaded({required this.question, required this.response});
}

class AiAdvisorError extends AiAdvisorState {
  final String question;
  final String message;

  AiAdvisorError({required this.question, required this.message});
}
