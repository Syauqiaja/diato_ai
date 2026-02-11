import '../../../../core/data/result.dart';
import '../../shared/models/user_model.dart';

abstract class LoginRepository {
  /// Authenticates a user with email and password.
  ///
  /// Sends a POST request to the login endpoint with the provided credentials.
  /// Returns a [Result] containing the authenticated [UserModel] on success,
  /// or an error message on failure.
  ///
  /// On successful login, the user and token are stored in AuthCore.
  ///
  /// Parameters:
  /// - [email]: The user's email address
  /// - [password]: The user's password
  Future<Result<UserModel>> login({required String email, required String password});

  /// Authenticates a user with Google Sign-In.
  ///
  /// Performs Google Sign-In flow using Firebase Auth,
  /// gets the ID token, and sends it to the backend for authentication.
  /// Returns a [Result] containing the authenticated [UserModel] on success,
  /// or an error message on failure.
  ///
  /// On successful login, the user and token are stored in AuthCore.
  Future<Result<UserModel>> loginWithGoogle();
}
