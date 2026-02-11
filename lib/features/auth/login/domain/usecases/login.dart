import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/data/usecase.dart';
import 'package:diato_ai/features/auth/login/domain/login_repository.dart';

import '../../../shared/models/user_model.dart';

final class Login extends Usecase<UserModel, LoginParams> {
  final LoginRepository _loginRepository;

  Login(this._loginRepository);

  @override
  Future<Result<UserModel>> call(LoginParams params) {
    return _loginRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}

final class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}