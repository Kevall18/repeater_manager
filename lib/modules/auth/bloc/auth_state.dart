import 'package:equatable/equatable.dart';

import '../models/app_user.dart';

enum AuthStatus { initializing, authenticated, unauthenticated, loading, error }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    required this.user,
    required this.message,
  });

  final AuthStatus status;
  final AppUser? user;
  final String message;

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initializing,
      user: null,
      message: '',
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, user, message];
}
