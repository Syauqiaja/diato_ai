import '../../../../core/data/result.dart';
import '../../shared/models/user_model.dart';

abstract class RegisterRepository {
  
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
  Future<Result<UserModel>> register({required String name, required String email, required String password});
}
