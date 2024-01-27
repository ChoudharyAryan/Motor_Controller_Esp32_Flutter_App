import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:motor_controller_esp32/services/auth/auth_provider.dart';
import 'package:motor_controller_esp32/services/auth/auth_user.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late AuthProvider provider;
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUnInitialized(isLoading: true)) {
    this.provider;
    on<AuthEventInitialize>(_initializeAuth);
    on<AuthEventLogin>(_logIn);
    on<AuthEventShouldRegister>(_shouldRegister);
    on<AuthEventRegister>(_register);
    on<AuthEventLogOut>(_logOut);
    on<AuthEventSendEmailVerificationEmail>(_sendEmailVerification);
    on<AuthEventForgotPassword>(_forgotPassword);
  }

  void _initializeAuth(
    AuthEventInitialize event,
    Emitter<AuthState> emit,
  ) async {
    await provider.initialize();
    final user = provider.currentUser;
    if (user == null) {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: false,
      ));
    } else if (!user.isEmailVerified) {
      emit(const AuthStateNeedsVerification(
        isLoading: false,
      ));
    } else {
      emit(AuthStateLoggedIn(
        user: user,
        isLoading: false,
      ));
    }
  }

  void _logIn(AuthEventLogin event, Emitter<AuthState> emit) async {
    emit(const AuthStateLoggedOut(
      exception: null,
      isLoading: true,
    ));
    final email = event.email;
    final password = event.password;
    try {
      final user = await provider.logIn(
        email: email,
        password: password,
      );
      if (!user.isEmailVerified) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(
        exception: e,
        isLoading: false,
      ));
    }
  }

  void _shouldRegister(AuthEventShouldRegister event, Emitter<AuthState> emit) {
    emit(const AuthStateRegistring(exception: null, isLoading: false));
  }

  void _register(AuthEventRegister event, Emitter<AuthState> emit) async {
    emit(const AuthStateRegistring(
      exception: null,
      isLoading: true,
    ));
    final email = event.email;
    final password = event.password;
    try {
      await provider.createUser(
        email: email,
        password: password,
      );
      await provider.sendEmailVerification();
      emit(const AuthStateNeedsVerification(isLoading: false));
    } on Exception catch (e) {
      emit(AuthStateRegistring(
        exception: e,
        isLoading: false,
      ));
    }
  }

  void _logOut(AuthEventLogOut event, Emitter<AuthState> emit) async {
    try {
      await provider.logOut();
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: false,
      ));
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(
        exception: e,
        isLoading: false,
      ));
    }
  }

  void _sendEmailVerification(AuthEventSendEmailVerificationEmail event,
      Emitter<AuthState> emit) async {
    await provider.sendEmailVerification();
    emit(state);
  }

  void _forgotPassword(
      AuthEventForgotPassword event, Emitter<AuthState> emit) async {
    emit(const AuthStateForgotPassword(
      exception: null,
      hasSentEmail: false,
      isLoading: false,
    ));
    final email = event.email;
    if (email == null) {
      return;
    }

    emit(const AuthStateForgotPassword(
      exception: null,
      hasSentEmail: false,
      isLoading: true,
    ));
    bool didSendEmail;
    Exception? exception;

    try {
      await provider.sendPasswordReset(toEmail: email);
      didSendEmail = true;
      exception = null;
    } on Exception catch (e) {
      exception = e;
      didSendEmail = false;
    }

    emit(AuthStateForgotPassword(
      exception: exception,
      hasSentEmail: didSendEmail,
      isLoading: false,
    ));
  }
}
