part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {}

/// Initial state when the cubit is first created
final class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

/// State when checking authentication status
final class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

/// State when user is authenticated
final class AuthAuthenticated extends AuthState {
  final UserModel user;

  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
final class AuthUnauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

/// State when an authentication error occurs
final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
