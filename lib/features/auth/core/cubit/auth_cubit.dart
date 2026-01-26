import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/di/injection.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/login/data/login_repository.dart';
import 'package:diato_ai/features/auth/register/data/register_repository.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCore _authCore;
  final LoginRepository _loginRepository;
  final RegisterRepository _registerRepository;
  StreamSubscription<UserModel?>? _userSubscription;

  AuthCubit({
    AuthCore? authCore,
    LoginRepository? loginRepository,
    RegisterRepository? registerRepository,
  }) : _authCore = authCore ?? getIt<AuthCore>(),
       _loginRepository = loginRepository ?? getIt<LoginRepository>(),
       _registerRepository = registerRepository ?? getIt<RegisterRepository>(),
       super(AuthInitial()) {
    _initialize();
  }

  /// Initialize the cubit and listen to auth state changes
  void _initialize() async {
    // Initialize AuthCore
    await _authCore.initialize();

    // Listen to user changes from AuthCore
    _userSubscription = _authCore.userChanges().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    // Check initial auth status
    await checkAuthStatus();
  }

  /// Check the current authentication status
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final user = await _authCore.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final result = await _loginRepository.login(
        email: email,
        password: password,
      );

      switch (result) {
        case Success<UserModel>():
          emit(AuthAuthenticated(result.data));
        case Failure<UserModel>():
          emit(AuthError(result.message));
          // Return to unauthenticated state after showing error
          await Future.delayed(const Duration(milliseconds: 100));
          emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AuthUnauthenticated());
    }
  }

  /// Register a new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final result = await _registerRepository.register(
        name: name,
        email: email,
        password: password,
      );

      switch (result) {
        case Success<UserModel>():
          emit(AuthAuthenticated(result.data));
        case Failure<UserModel>():
          emit(AuthError(result.message));
          // Return to unauthenticated state after showing error
          await Future.delayed(const Duration(milliseconds: 100));
          emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AuthUnauthenticated());
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await _authCore.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Failed to logout'));
      await Future.delayed(const Duration(milliseconds: 100));
      // Still emit unauthenticated even if logout fails
      emit(AuthUnauthenticated());
    }
  }

  /// Sign in with Google (placeholder - requires Firebase/Google Sign-In setup)
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    try {
      final result = await _loginRepository.loginWithGoogle();

      switch (result) {
        case Success<UserModel>():
          emit(AuthAuthenticated(result.data));
        case Failure<UserModel>():
          emit(AuthError(result.message));
          // Return to unauthenticated state after showing error
          await Future.delayed(const Duration(milliseconds: 100));
          emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Google sign-in error: ${e.toString()}'));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
