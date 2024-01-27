part of 'auth_bloc_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}

class AuthEventSendEmailVerificationEmail extends AuthEvent {
  final String email;
  const AuthEventSendEmailVerificationEmail(this.email);
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin(this.email, this.password);
}

class AuthEventForgotPassword extends AuthEvent {
  final String email;
  const AuthEventForgotPassword(this.email);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
