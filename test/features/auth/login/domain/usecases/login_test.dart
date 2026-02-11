import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/auth/login/domain/login_repository.dart';
import 'package:diato_ai/features/auth/login/domain/usecases/login.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late LoginRepository loginRepository;
  late Login login;
  final Result<UserModel> tUserModel = Result.success(UserModel(0, 'Test User', 'test@example.com'));
  final LoginParams tLoginParams = LoginParams(email: 'Test User', password: 'password123');

  setUp(() {
    loginRepository = MockLoginRepository();
    login = Login(loginRepository);
  });

  test('should call LoginRepository.login', () {
    when(() => loginRepository.login(email: any(named: 'email'), password: any(named: 'password'))).thenAnswer((_) async => tUserModel);

    login(tLoginParams);

    verify(() => loginRepository.login(email: any(named: 'email'), password: any(named: 'password')));
  });

  test('should pass correct params to LoginRepository.login', () {
    when(() => loginRepository.login(email: any(named: 'email'), password: any(named: 'password'))).thenAnswer((_) async => tUserModel);

    login(tLoginParams);
    
    verify(() => loginRepository.login(email: tLoginParams.email, password: tLoginParams.password));
  });
}
