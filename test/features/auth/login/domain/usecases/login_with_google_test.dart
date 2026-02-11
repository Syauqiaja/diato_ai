import 'package:diato_ai/core/data/no_params.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/auth/login/domain/login_repository.dart';
import 'package:diato_ai/features/auth/login/domain/usecases/login_with_google.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late LoginRepository loginRepository;
  late LoginWithGoogle loginWithGoogle;
  final Result<UserModel> tUserModel = Result.success(UserModel(0, 'Test User', 'test@example.com'));
  final NoParams tLoginParams = NoParams();

  setUp(() {
    loginRepository = MockLoginRepository();
    loginWithGoogle = LoginWithGoogle(loginRepository);
  });

  test('should call LoginRepository.loginWithGoogle', () {
    when(() => loginRepository.loginWithGoogle()).thenAnswer((_) async => tUserModel);

    loginWithGoogle(tLoginParams);

    verify(() => loginRepository.loginWithGoogle());
  });
}
