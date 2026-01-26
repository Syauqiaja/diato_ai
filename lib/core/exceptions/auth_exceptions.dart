sealed class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({required this.message, this.code});

  @override
  String toString() => message;
}

// Login exceptions
final class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException()
    : super(message: 'Invalid email or password', code: 'invalid-credentials');
}

final class UserNotFoundException extends AuthException {
  UserNotFoundException()
    : super(message: 'User not found', code: 'user-not-found');
}

final class UserDisabledException extends AuthException {
  UserDisabledException()
    : super(message: 'This account has been disabled', code: 'user-disabled');
}

final class WrongPasswordException extends AuthException {
  WrongPasswordException()
    : super(message: 'Wrong password', code: 'wrong-password');
}

// Google Sign-In exceptions
final class GoogleSignInCanceledException extends AuthException {
  GoogleSignInCanceledException()
    : super(message: 'Sign-in canceled', code: 'popup-closed-by-user');
}

final class GoogleSignInFailedException extends AuthException {
  GoogleSignInFailedException([String? reason])
    : super(
        message: reason ?? 'Failed to authenticate with Google',
        code: 'google-sign-in-failed',
      );
}

final class AccountExistsWithDifferentCredentialException
    extends AuthException {
  AccountExistsWithDifferentCredentialException()
    : super(
        message: 'An account already exists with a different sign-in method',
        code: 'account-exists-with-different-credential',
      );
}

final class OperationNotAllowedException extends AuthException {
  OperationNotAllowedException([String operation = 'This operation'])
    : super(
        message: '$operation is not enabled',
        code: 'operation-not-allowed',
      );
}

final class InvalidTokenException extends AuthException {
  InvalidTokenException()
    : super(
        message: 'Failed to get authentication token',
        code: 'invalid-token',
      );
}

// Registration exceptions
final class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException()
    : super(
        message: 'This email is already registered',
        code: 'email-already-in-use',
      );
}

final class WeakPasswordException extends AuthException {
  WeakPasswordException()
    : super(message: 'Password is too weak', code: 'weak-password');
}

final class InvalidEmailException extends AuthException {
  InvalidEmailException()
    : super(message: 'Invalid email address', code: 'invalid-email');
}

// Network exceptions
final class NetworkException extends AuthException {
  NetworkException([String? details])
    : super(
        message: details ?? 'Network error occurred',
        code: 'network-error',
      );
}

// Server exceptions
final class ServerException extends AuthException {
  ServerException([String? details])
    : super(message: details ?? 'Server error occurred', code: 'server-error');
}

// Generic auth exception
final class UnknownAuthException extends AuthException {
  UnknownAuthException([String? details])
    : super(
        message: details ?? 'An unknown error occurred',
        code: 'unknown-error',
      );
}
