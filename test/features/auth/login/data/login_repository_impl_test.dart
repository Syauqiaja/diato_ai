import 'package:diato_ai/core/exceptions/auth_exceptions.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/login/data/login_repository_impl.dart';
import 'package:diato_ai/features/auth/login/domain/login_repository.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockAuthCore extends Mock implements AuthCore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late Dio dio;
  late AuthCore authCore;
  late LoginRepositoryImpl loginRepository;
  late FirebaseAuth firebaseAuth;

  setUpAll(() {
    // Register fallback values for any() matchers
    registerFallbackValue(UserModel(0, '', ''));
    registerFallbackValue(GoogleAuthProvider());
  });

  setUp(() {
    dio = MockDio();
    authCore = MockAuthCore();
    firebaseAuth = MockFirebaseAuth();
    loginRepository = LoginRepositoryImpl(dio, authCore, firebaseAuth);
  });

  group('LoginRepositoryImpl', () {
    test('should have LoginRepositoryImpl extends LoginRepository', () {
      expect(loginRepository, isA<LoginRepository>());
    });
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tName = 'Test User';
    const tToken = 'test_token';

    test('should return UserModel when login succeeds with status 200',
        () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          statusCode: 200,
          data: {
            'data': {
              'user': {'id': 1, 'name': tName, 'email': tEmail},
              'token': tToken,
            },
          },
        ),
      );

      when(() => authCore.setUser(any(), any())).thenAnswer((_) async => {});

      // act
      final result = await loginRepository.login(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result.isSuccess, true);
      expect(result.data?.email, tEmail);
      expect(result.data?.name, tName);
      verify(
        () => dio.post(
          '/login',
          data: {'email': tEmail, 'password': tPassword},
        ),
      );
      verify(() => authCore.setUser(any(), tToken));
    });

    test('should store user and token in AuthCore on success', () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          statusCode: 200,
          data: {
            'data': {
              'user': {'id': 1, 'name': tName, 'email': tEmail},
              'token': tToken,
            },
          },
        ),
      );

      when(() => authCore.setUser(any(), any())).thenAnswer((_) async => {});

      // act
      await loginRepository.login(
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(
        () => authCore.setUser(
          any<UserModel>(),
          tToken,
        ),
      ).called(1);
    });

    test('should throw InvalidCredentialsException when status 401',
        () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 401,
            data: {'message': 'Invalid credentials'},
          ),
        ),
      );

      // act & assert
      expect(
        () => loginRepository.login(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });

    test('should throw UserNotFoundException when status 404', () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 404,
            data: {'message': 'User not found'},
          ),
        ),
      );

      // act & assert
      expect(
        () => loginRepository.login(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<UserNotFoundException>()),
      );
    });

    test('should throw UserDisabledException when status 403', () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 403,
            data: {'message': 'User account is disabled'},
          ),
        ),
      );

      // act & assert
      expect(
        () => loginRepository.login(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<UserDisabledException>()),
      );
    });

    test('should throw ServerException when response has error message',
        () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );

      // act & assert
      expect(
        () => loginRepository.login(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(
          predicate(
            (e) => e is ServerException && e.message == 'Internal server error',
          ),
        ),
      );
    });

    test('should throw NetworkException when DioException has no response',
        () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          message: 'No internet connection',
        ),
      );

      // act & assert
      expect(
        () => loginRepository.login(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw UnknownAuthException when unexpected error occurs',
        () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data')))
          .thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(
        () => loginRepository.login(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<UnknownAuthException>()),
      );
    });

    test('should throw ServerException when status code is not 200', () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          statusCode: 403,
          data: {'message': 'Forbidden'},
        ),
      );

      // act & assert
      expect(
        () => loginRepository.login(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(
          predicate((e) => e is ServerException && e.message == 'Forbidden'),
        ),
      );
    });

    test('should rethrow AuthException when caught', () async {
      // arrange
      when(() => dio.post('/login', data: any(named: 'data')))
          .thenThrow(InvalidCredentialsException());

      // act & assert
      expect(
        () => loginRepository.login(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });
  });

  group('loginWithGoogle', () {
    const tEmail = 'test@example.com';
    const tName = 'Test User';
    const tToken = 'test_token';
    const tIdToken = 'firebase_id_token';

    test('should return UserModel when Google login succeeds', () async {
      // arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(() => mockUser.getIdToken()).thenAnswer((_) async => tIdToken);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => mockUserCredential);

      when(() => dio.post('/login-with-token', data: any(named: 'data')))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/login-with-token'),
          statusCode: 200,
          data: {
            'data': {
              'user': {'id': 1, 'name': tName, 'email': tEmail},
              'token': tToken,
            },
          },
        ),
      );

      when(() => authCore.setUser(any(), any())).thenAnswer((_) async => {});

      // act
      final result = await loginRepository.loginWithGoogle();

      // assert
      expect(result.isSuccess, true);
      expect(result.data?.email, tEmail);
      expect(result.data?.name, tName);
      verify(() => firebaseAuth.signInWithProvider(any()));
      verify(() => dio.post('/login-with-token', data: {'token': tIdToken}));
      verify(() => authCore.setUser(any(), tToken));
    });

    test('should store user and token in AuthCore on success', () async {
      // arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(() => mockUser.getIdToken()).thenAnswer((_) async => tIdToken);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => mockUserCredential);

      when(() => dio.post('/login-with-token', data: any(named: 'data')))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/login-with-token'),
          statusCode: 200,
          data: {
            'data': {
              'user': {'id': 1, 'name': tName, 'email': tEmail},
              'token': tToken,
            },
          },
        ),
      );

      when(() => authCore.setUser(any(), any())).thenAnswer((_) async => {});

      // act
      await loginRepository.loginWithGoogle();

      // assert
      verify(
        () => authCore.setUser(
          any<UserModel>(),
          tToken,
        ),
      ).called(1);
    });

    test('should throw GoogleSignInFailedException when user is null',
        () async {
      // arrange
      final mockUserCredential = MockUserCredential();

      when(() => mockUserCredential.user).thenReturn(null);
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => mockUserCredential);

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<GoogleSignInFailedException>()),
      );
    });

    test('should throw InvalidTokenException when idToken is null', () async {
      // arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(() => mockUser.getIdToken()).thenAnswer((_) async => null);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => mockUserCredential);

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<InvalidTokenException>()),
      );
    });

    test(
        'should throw AccountExistsWithDifferentCredentialException for Firebase error',
        () async {
      // arrange
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(
        FirebaseAuthException(
          code: 'account-exists-with-different-credential',
        ),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<AccountExistsWithDifferentCredentialException>()),
      );
    });

    test('should throw InvalidCredentialsException for invalid-credential',
        () async {
      // arrange
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(
        FirebaseAuthException(code: 'invalid-credential'),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });

    test('should throw OperationNotAllowedException for operation-not-allowed',
        () async {
      // arrange
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(
        FirebaseAuthException(code: 'operation-not-allowed'),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<OperationNotAllowedException>()),
      );
    });

    test('should throw UserDisabledException for user-disabled', () async {
      // arrange
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(
        FirebaseAuthException(code: 'user-disabled'),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<UserDisabledException>()),
      );
    });

    test('should throw GoogleSignInCanceledException for popup-closed-by-user',
        () async {
      // arrange
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(
        FirebaseAuthException(code: 'popup-closed-by-user'),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<GoogleSignInCanceledException>()),
      );
    });

    test('should throw GoogleSignInFailedException for unknown Firebase error',
        () async {
      // arrange
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(
        FirebaseAuthException(code: 'unknown-error', message: 'Unknown error'),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<GoogleSignInFailedException>()),
      );
    });

    test('should throw ServerException when backend returns error', () async {
      // arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(() => mockUser.getIdToken()).thenAnswer((_) async => tIdToken);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => mockUserCredential);

      when(() => dio.post('/login-with-token', data: any(named: 'data')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login-with-token'),
          response: Response(
            requestOptions: RequestOptions(path: '/login-with-token'),
            statusCode: 500,
            data: {'message': 'Server error'},
          ),
        ),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(
          predicate((e) => e is ServerException && e.message == 'Server error'),
        ),
      );
    });

    test('should throw NetworkException when DioException has no response',
        () async {
      // arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(() => mockUser.getIdToken()).thenAnswer((_) async => tIdToken);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => mockUserCredential);

      when(() => dio.post('/login-with-token', data: any(named: 'data')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login-with-token'),
          message: 'No internet connection',
        ),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw UnknownAuthException when unexpected error occurs',
        () async {
      // arrange
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<UnknownAuthException>()),
      );
    });

    test('should throw ServerException when backend status is not 200',
        () async {
      // arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(() => mockUser.getIdToken()).thenAnswer((_) async => tIdToken);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => mockUserCredential);

      when(() => dio.post('/login-with-token', data: any(named: 'data')))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/login-with-token'),
          statusCode: 403,
          data: {'message': 'Forbidden'},
        ),
      );

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(
          predicate((e) => e is ServerException && e.message == 'Forbidden'),
        ),
      );
    });

    test('should rethrow AuthException when caught', () async {
      // arrange
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenThrow(GoogleSignInFailedException());

      // act & assert
      expect(
        () => loginRepository.loginWithGoogle(),
        throwsA(isA<GoogleSignInFailedException>()),
      );
    });
  });
}