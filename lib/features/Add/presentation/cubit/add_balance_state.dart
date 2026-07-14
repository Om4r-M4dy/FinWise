abstract class AddBalanceState {}

class AddBalanceInitial extends AddBalanceState {}

class AddBalanceLoading extends AddBalanceState {}

class AddBalanceSuccess extends AddBalanceState {}

class AddBalanceFailure extends AddBalanceState {
  final String errorMessage;
  AddBalanceFailure({required this.errorMessage});
}
