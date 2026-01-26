import 'package:diato_ai/core/data/base_repository.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/exceptions/auth_exceptions.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/shared/models/auth_response.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:dio/dio.dart';

final class RegisterRepository extends BaseRepository {
  final _authCore = AuthCore();

  /// Registers a new user with the provided information.
  ///
  /// Sends a POST request to the registration endpoint with user details.
  /// Returns a [Result] containing the newly created [UserModel] on success,
  /// or an error message on failure.
  ///
  /// On successful registration, the user and token are stored in AuthCore.
  ///
  /// Parameters:
  /// - [name]: The user's full name
  /// - [email]: The user's email address
  /// - [password]: The user's password
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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

        if (statusCode == 409 || statusCode == 400) {
          // Check if error message indicates email already exists
          if (message?.toLowerCase().contains('email') ?? false) {
            throw EmailAlreadyInUseException();
          } else if (message?.toLowerCase().contains('password') ?? false) {
            throw WeakPasswordException();
          }
        }
        throw ServerException(message);
      }
      throw NetworkException(e.message);
    } catch (e) {
      throw UnknownAuthException(e.toString());
    }
  }
}
