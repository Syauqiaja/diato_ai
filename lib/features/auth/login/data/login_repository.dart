import 'package:diato_ai/core/data/base_repository.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/exceptions/auth_exceptions.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/shared/models/auth_response.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class LoginRepository extends BaseRepository {
  final _authCore = AuthCore();
  final _firebaseAuth = FirebaseAuth.instance;

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
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data['data']);

        // Store user and token in AuthCore
        await _authCore.setUser(authResponse.user, authResponse.token);

        return Result.success(authResponse.user);
      } else {
        throw ServerException(response.data['message']);
      }
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response?.data['message'];

        if (statusCode == 401) {
          throw InvalidCredentialsException();
        } else if (statusCode == 404) {
          throw UserNotFoundException();
        } else if (statusCode == 403) {
          throw UserDisabledException();
        } else {
          throw ServerException(message);
        }
      }
      throw NetworkException(e.message);
    } catch (e) {
      throw UnknownAuthException(e.toString());
    }
  }

  /// Authenticates a user with Google Sign-In.
  ///
  /// Performs Google Sign-In flow using Firebase Auth,
  /// gets the ID token, and sends it to the backend for authentication.
  /// Returns a [Result] containing the authenticated [UserModel] on success,
  /// or an error message on failure.
  ///
  /// On successful login, the user and token are stored in AuthCore.
  Future<Result<UserModel>> loginWithGoogle() async {
    try {
      // Create Google provider
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      // Trigger the sign-in flow
      final UserCredential userCredential = await _firebaseAuth
          .signInWithProvider(googleProvider);

      if (userCredential.user == null) {
        throw GoogleSignInFailedException();
      }

      // Get Firebase ID token to send to backend
      final String? idToken = await userCredential.user!.getIdToken();

      if (idToken == null) {
        throw InvalidTokenException();
      }

      // Send token to backend for verification and user creation/login
      final response = await dio.post(
        '$baseUrl/login-with-token',
        data: {'token': idToken},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data['data']);

        // Store user and token in AuthCore
        await _authCore.setUser(authResponse.user, authResponse.token);

        return Result.success(authResponse.user);
      } else {
        throw ServerException(response.data['message']);
      }
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw AccountExistsWithDifferentCredentialException();
        case 'invalid-credential':
          throw InvalidCredentialsException();
        case 'operation-not-allowed':
          throw OperationNotAllowedException('Google sign-in');
        case 'user-disabled':
          throw UserDisabledException();
        case 'popup-closed-by-user':
          throw GoogleSignInCanceledException();
        default:
          throw GoogleSignInFailedException(e.message);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.data['message']);
      }
      throw NetworkException(e.message);
    } catch (e) {
      throw UnknownAuthException(e.toString());
    }
  }
}
