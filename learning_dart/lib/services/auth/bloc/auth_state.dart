import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:learning_dart/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLoginError extends AuthState {
  final Exception exception;
  const AuthStateLoginError(this.exception);
}

class AuthStatePendingVerification extends AuthState {
  const AuthStatePendingVerification();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLoggedOutError extends AuthState {
  final Exception exception;
  const AuthStateLoggedOutError(this.exception);
}
