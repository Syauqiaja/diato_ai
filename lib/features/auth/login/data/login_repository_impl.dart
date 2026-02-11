import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/exceptions/auth_exceptions.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/shared/models/auth_response.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/login_repository.dart';

final class LoginRepositoryImpl extends LoginRepository {
  final Dio _dio;
  final AuthCore _authCore;
  final FirebaseAuth _firebaseAuth;

  LoginRepositoryImpl(this._dio, this._authCore, this._firebaseAuth);

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
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

  @override
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
      final response = await _dio.post(
        '/login-with-token',
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
