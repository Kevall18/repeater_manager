import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/validation/app_validators.dart';
import '../models/app_user.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _isTestMode = false,
        super(AuthState.initial()) {
    _subscription =
        _authRepository!.authStateChanges().listen(_handleAuthChange);
  }

  AuthCubit.test()
      : _authRepository = null,
        _userRepository = null,
        _isTestMode = true,
        super(
          const AuthState(
            status: AuthStatus.unauthenticated,
            user: null,
            message: '',
          ),
        );

  final AuthRepository? _authRepository;
  final UserRepository? _userRepository;
  final bool _isTestMode;
  StreamSubscription? _subscription;

  Future<void> _handleAuthChange(User? firebaseUser) async {
    if (firebaseUser == null) {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated, user: null, message: ''));
      return;
    }

    final email = (firebaseUser.email ?? '').trim();
    final name = (firebaseUser.displayName ?? '').trim().isNotEmpty
        ? firebaseUser.displayName!.trim()
        : email.split('@').first;
    final now = DateTime.now();
    final existingUser = await _userRepository!.fetchUser(firebaseUser.uid);
    final appUser = (existingUser ??
            AppUser(
              uid: firebaseUser.uid,
              email: email,
              name: name,
              createdAt: now,
              updatedAt: now,
            ))
        .copyWith(
      email: email.isEmpty ? name : email,
      name: name,
      updatedAt: now,
    );

    await _userRepository!.upsertUser(appUser);
    emit(state.copyWith(
        status: AuthStatus.authenticated, user: appUser, message: ''));
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    final emailError = AppValidators.email(trimmedEmail);
    if (emailError != null) {
      return emailError;
    }

    final passwordError = AppValidators.password(trimmedPassword);
    if (passwordError != null) {
      return passwordError;
    }

    emit(state.copyWith(status: AuthStatus.loading, message: ''));

    try {
      if (_isTestMode) {
        return 'Auth is disabled in test mode.';
      }

      await _authRepository!
          .signIn(email: trimmedEmail, password: trimmedPassword);
      return null;
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.error, message: error.toString()));
      return 'Unable to sign in. Please check your credentials.';
    }
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedConfirmPassword = confirmPassword.trim();

    final nameError =
        AppValidators.requiredTrimmed(trimmedName, fieldName: 'Name');
    if (nameError != null) {
      return nameError;
    }

    final emailError = AppValidators.email(trimmedEmail);
    if (emailError != null) {
      return emailError;
    }

    final passwordError = AppValidators.password(trimmedPassword);
    if (passwordError != null) {
      return passwordError;
    }

    final confirmPasswordError =
        AppValidators.confirmPassword(trimmedConfirmPassword, trimmedPassword);
    if (confirmPasswordError != null) {
      return confirmPasswordError;
    }

    emit(state.copyWith(status: AuthStatus.loading, message: ''));

    try {
      if (_isTestMode) {
        return 'Auth is disabled in test mode.';
      }

      await _authRepository!.signUp(
        name: trimmedName,
        email: trimmedEmail,
        password: trimmedPassword,
      );
      await _authRepository!.updateDisplayName(trimmedName);
      final currentUser = _authRepository!.currentUser;
      if (currentUser != null) {
        final now = DateTime.now();
        final userRepository = _userRepository;
        if (userRepository == null) {
          return 'Unable to create account. Please try again.';
        }

        await userRepository.upsertUser(
          AppUser(
            uid: currentUser.uid,
            email: trimmedEmail,
            name: trimmedName,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
      return null;
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.error, message: error.toString()));
      return 'Unable to create account. Please try again.';
    }
  }

  Future<void> signOut() async {
    if (_isTestMode) {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated, user: null, message: ''));
      return;
    }

    await _authRepository!.signOut();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
