part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});
}

final class RegisterEvent extends AuthEvent {
  final Map<String, dynamic> user;

  const RegisterEvent({required this.user});
}

final class LogoutEvent extends AuthEvent {}
