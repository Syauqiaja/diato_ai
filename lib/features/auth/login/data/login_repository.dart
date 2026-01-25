import 'package:diato_ai/core/data/base_repository.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/shared/models/auth_response.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:dio/dio.dart';

final class LoginRepository extends BaseRepository {
  final _authCore = AuthCore();

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
        return Result.failure(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Result.failure(e.response?.data['message'] ?? 'Login failed');
      }
      return Result.failure('An error occurred: ${e.message}');
    } catch (e) {
      return Result.failure('An error occurred: ${e.toString()}');
    }
  }
}
