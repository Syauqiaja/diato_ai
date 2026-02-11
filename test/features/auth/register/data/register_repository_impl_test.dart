import 'package:diato_ai/core/exceptions/auth_exceptions.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/register/data/register_repository_impl.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockAuthCore extends Mock implements AuthCore {}

void main() {
  late RegisterRepositoryImpl registerRepository;
  late Dio mockDio;
  late AuthCore mockAuthCore;

  setUpAll(() {
    // Register fallback values for any() matchers
    registerFallbackValue(UserModel(0, '', ''));
  });

  setUp(() {
    mockDio = MockDio();
    mockAuthCore = MockAuthCore();
    registerRepository = RegisterRepositoryImpl(mockDio, mockAuthCore);
  });

  group('register success', () {
    final email = 'test@example.com';
    final password = 'password123';
    final name = 'Test User';
    final token = 'test_token';
    final tResponse = Response(
      requestOptions: RequestOptions(path: '/register'),
      statusCode: 200,
      data: {
        'data': {
          'user': {'id': 0, 'email': email, 'name': name},
          'token': token,
        },
      },
    );

    test('should return UserModel when registration succeeds with status 200', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenAnswer((_) async => tResponse);

      when(() => mockAuthCore.setUser(any(), any())).thenAnswer((_) async => {});

      // act
      final result = await registerRepository.register(name: name, email: email, password: password);

      // assert
      expect(result.isSuccess, true);
      expect(result.data?.email, email);
      expect(result.data?.name, name);
      verify(() => mockDio.post('/register', data: {'name': name, 'email': email, 'password': password}));
      verify(() => mockAuthCore.setUser(any(), token));
    });

    test('should return UserModel when registration succeeds with status 201', () async {
      // arrange
      tResponse.statusCode = 201;
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenAnswer((_) async => tResponse);

      when(() => mockAuthCore.setUser(any(), any())).thenAnswer((_) async => {});

      // act
      final result = await registerRepository.register(name: name, email: email, password: password);

      // assert
      expect(result.isSuccess, true);
      expect(result.data?.email, email);
      verify(() => mockAuthCore.setUser(any(), token));
    });

    test('should store user and token in AuthCore on success', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenAnswer((_) async => tResponse);

      when(() => mockAuthCore.setUser(any(), any())).thenAnswer((_) async => {});

      // act
      await registerRepository.register(name: name, email: email, password: password);

      // assert
      verify(() => mockAuthCore.setUser(any<UserModel>(that: predicate<UserModel>((user) => user.email == email && user.name == name)), token)).called(1);
    });
  });

  group('register failure', () {
    final email = 'existing@example.com';
    final password = 'password123';
    final name = 'Test User';

    test('should throw EmailAlreadyInUseException when status 409 with email in message', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/register'),
            statusCode: 409,
            data: {'message': 'Email already exists'},
          ),
        ),
      );

      // act & assert
      expect(() => registerRepository.register(name: name, email: email, password: password), throwsA(isA<EmailAlreadyInUseException>()));
    });

    test('should throw EmailAlreadyInUseException when status 400 with email in message', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/register'),
            statusCode: 400,
            data: {'message': 'Invalid email format'},
          ),
        ),
      );

      // act & assert
      expect(() => registerRepository.register(name: name, email: email, password: password), throwsA(isA<EmailAlreadyInUseException>()));
    });

    test('should throw WeakPasswordException when status 400 with password in message', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/register'),
            statusCode: 400,
            data: {'message': 'Password must be at least 8 characters'},
          ),
        ),
      );

      // act & assert
      expect(() => registerRepository.register(name: name, email: email, password: password), throwsA(isA<WeakPasswordException>()));
    });

    test('should throw ServerException when response has error message', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/register'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      // act & assert
      expect(() => registerRepository.register(name: name, email: email, password: password), throwsA(predicate((e) => e is ServerException && e.message == 'Internal server error')));
    });

    test('should throw NetworkException when DioException has no response', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          message: 'No internet connection',
        ),
      );

      // act & assert
      expect(() => registerRepository.register(name: name, email: email, password: password), throwsA(isA<NetworkException>()));
    });

    test('should throw UnknownAuthException when unexpected error occurs', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(() => registerRepository.register(name: name, email: email, password: password), throwsA(isA<UnknownAuthException>()));
    });

    test('should throw ServerException when status code is not 200 or 201', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/register'),
          statusCode: 403,
          data: {'message': 'Forbidden'},
        ),
      );

      // act & assert
      expect(() => registerRepository.register(name: name, email: email, password: password), throwsA(predicate((e) => e is ServerException && e.message == 'Forbidden')));
    });

    test('should rethrow AuthException when caught', () async {
      // arrange
      when(() => mockDio.post('/register', data: any(named: 'data'))).thenThrow(EmailAlreadyInUseException());

      // act & assert
      expect(() => registerRepository.register(name: name, email: email, password: password), throwsA(isA<EmailAlreadyInUseException>()));
    });
  });
}
