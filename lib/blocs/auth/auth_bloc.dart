import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_tracking_flutter/models/user_model.dart';
import 'package:user_tracking_flutter/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthRepository repository)
      : _repository = repository,
        super(const AuthInitial()) {
    on<LoginEvent>(_mapLoginEventToState);
    on<RegisterEvent>(_mapRegisterEventToState);
    on<LogoutEvent>(_mapLogoutEventToState);
  }

  final AuthRepository _repository;

  FutureOr<void> _mapLoginEventToState(
      LoginEvent event, Emitter<AuthState> emit) async {
    final user =
        await _repository.login(email: event.email, password: event.password);
    emit(state.copyWith(user: user, isAuth: true));
  }

  FutureOr<void> _mapRegisterEventToState(
      RegisterEvent event, Emitter<AuthState> emit) async {
    final user = await _repository.register(
        name: event.user['name'],
        email: event.user['email'],
        password: event.user['password'],
        confirmPassword: event.user['confirmPassword']);
    emit(state.copyWith(user: user, isAuth: true));
  }

  FutureOr<void> _mapLogoutEventToState(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthInitial());
  }
}
