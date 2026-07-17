import 'package:finwise/features/profile/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel userModel;
  AuthSuccess({required this.userModel});
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}
