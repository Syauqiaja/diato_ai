import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/auth/register/domain/register_repository.dart';
import 'package:diato_ai/features/auth/register/domain/usecases/register.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  late RegisterRepository registerRepository;
  late Register register;
  setUp(() {
    registerRepository = MockRegisterRepository();
    register = Register(registerRepository);
  });

  test('should call RegisterRepository.register', (){
    final name = 'Test User';
    final email = 'email@email.com';
    final password = 'password123';
    final tUser = UserModel(0, name, email);

    when(() => registerRepository.register(
      name: name,
      email: email,
      password: password,
    )).thenAnswer((_) async => Result.success(tUser));

    register(
      RegisterParams(email: email, password: password, name: name),
    );

    verify(() => registerRepository.register(
      name: name,
      email: email,
      password: password,
    ));
  });
}