abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class PasswordVerificationLoading extends DeleteAccountState {}

class PasswordVerificationSuccess extends DeleteAccountState {}

class PasswordVerificationFailure extends DeleteAccountState {
  final String errorMessage;
  PasswordVerificationFailure(this.errorMessage);
}

class AccountDeletionLoading extends DeleteAccountState {}

class AccountDeletionSuccess extends DeleteAccountState {}

class AccountDeletionFailure extends DeleteAccountState {
  final String errorMessage;
  AccountDeletionFailure(this.errorMessage);
}
