import 'package:diato_ai/core/data/no_params.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/data/usecase.dart';
import 'package:diato_ai/features/auth/login/domain/login_repository.dart';

import '../../../shared/models/user_model.dart';

final class LoginWithGoogle extends Usecase<UserModel, NoParams> {
  final LoginRepository _loginRepository;

  LoginWithGoogle(this._loginRepository);
  @override
  Future<Result<UserModel>> call(NoParams params) {
    return _loginRepository.loginWithGoogle();
  }
}