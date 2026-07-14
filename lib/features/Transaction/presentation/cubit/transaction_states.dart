sealed class TransactionStates {}

class TransactionInitialState extends TransactionStates {}

class TransactionLoadingState extends TransactionStates {}

class TransactionSuccessState extends TransactionStates {}

class TransactionErrorState extends TransactionStates {
  final String errorMessage;

  TransactionErrorState(this.errorMessage);
}
