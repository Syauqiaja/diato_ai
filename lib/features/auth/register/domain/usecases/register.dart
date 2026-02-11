import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/data/usecase.dart';
import 'package:diato_ai/features/auth/register/domain/register_repository.dart';

import '../../../shared/models/user_model.dart';

final class Register extends Usecase<UserModel, RegisterParams> {
  final RegisterRepository registerRepository;

  Register(this.registerRepository);
  @override
  Future<Result<UserModel>> call(RegisterParams params) {
    return registerRepository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

final class RegisterParams {
  final String email;
  final String password;
  final String name;

  RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
}