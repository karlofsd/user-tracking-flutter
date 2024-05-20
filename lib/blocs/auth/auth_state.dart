part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState({this.isAuth = false, this.user});

  final User? user;
  final bool isAuth;

  @override
  List<Object> get props => [isAuth];

  AuthState copyWith({User? user, bool? isAuth});
}

final class AuthInitial extends AuthState {
  const AuthInitial({super.user, super.isAuth});

  @override
  AuthState copyWith({User? user, bool? isAuth}) {
    return AuthInitial(
      user: user ?? super.user,
      isAuth: isAuth ?? super.isAuth,
    );
  }
}
