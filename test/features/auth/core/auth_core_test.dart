import 'dart:convert';

import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/shared/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthCore authCore;
  late FirebaseAuth mockFirebaseAuth;
  final tUser = UserModel(1, 'test@example.com', 'Test User');
  final tToken = 'test_token_123';

  setUp(() {
    // Reset the singleton instance before each test
    mockFirebaseAuth = MockFirebaseAuth();
    authCore = AuthCore(mockFirebaseAuth);
  });

  tearDown(() {
    authCore.dispose();
  });

  group('initialize', () {
    test('should load user and token from SharedPreferences when data exists', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });

      // act
      await authCore.initialize();
      final user = await authCore.getCurrentUser();
      final token = await authCore.getToken();

      // assert
      expect(user, isNotNull);
      expect(user?.id, tUser.id);
      expect(user?.email, tUser.email);
      expect(user?.name, tUser.name);
      expect(token, tToken);
    });

    test('should return null when no data exists in SharedPreferences', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      await authCore.initialize();
      final user = await authCore.getCurrentUser();
      final token = await authCore.getToken();

      // assert
      expect(user, isNull);
      expect(token, isNull);
    });

    test('should clear storage when user data is invalid JSON', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': 'invalid_json',
        'auth_token': tToken,
      });

      // act
      await authCore.initialize();
      final prefs = await SharedPreferences.getInstance();

      // assert
      expect(prefs.getString('user_data'), isNull);
      expect(prefs.getString('auth_token'), isNull);
    });

    test('should emit auth state true when token exists', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });

      // act
      final authStateStream = authCore.authChanges();
      authCore.initialize();

      // assert
      await expectLater(authStateStream, emits(true));
    });

    test('should emit auth state false when no token exists', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      final authStateStream = authCore.authChanges();
      authCore.initialize();

      // assert
      await expectLater(authStateStream, emits(false));
    });

    test('should emit user when user data exists', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });

      // act
      final userStateStream = authCore.userChanges();
      authCore.initialize();

      // assert
      await expectLater(
        userStateStream,
        emits(predicate<UserModel>((user) => user.email == tUser.email)),
      );
    });
  });

  group('setUser', () {
    test('should save user and token to SharedPreferences', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      await authCore.setUser(tUser, tToken);
      final prefs = await SharedPreferences.getInstance();

      // assert
      expect(prefs.getString('user_data'), jsonEncode(tUser.toJson()));
      expect(prefs.getString('auth_token'), tToken);
    });

    test('should update current user and token', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      await authCore.setUser(tUser, tToken);
      final user = await authCore.getCurrentUser();
      final token = await authCore.getToken();

      // assert
      expect(user?.id, tUser.id);
      expect(user?.email, tUser.email);
      expect(user?.name, tUser.name);
      expect(token, tToken);
    });

    test('should emit auth state true', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      final authStateStream = authCore.authChanges();
      authCore.setUser(tUser, tToken);

      // assert
      await expectLater(authStateStream, emits(true));
    });

    test('should emit user state with user data', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      final userStateStream = authCore.userChanges();
      authCore.setUser(tUser, tToken);

      // assert
      await expectLater(
        userStateStream,
        emits(predicate<UserModel>((user) => user.email == tUser.email)),
      );
    });
  });

  group('logout', () {
    test('should clear user and token from SharedPreferences', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });
      await authCore.initialize();

      // act
      await authCore.logout();
      final prefs = await SharedPreferences.getInstance();

      // assert
      expect(prefs.getString('user_data'), isNull);
      expect(prefs.getString('auth_token'), isNull);
    });

    test('should clear current user and token', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });
      await authCore.initialize();

      // act
      await authCore.logout();
      final user = await authCore.getCurrentUser();
      final token = await authCore.getToken();

      // assert
      expect(user, isNull);
      expect(token, isNull);
    });

    test('should emit auth state false', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });
      await authCore.initialize();

      // act
      final authStateStream = authCore.authChanges();
      authCore.logout();

      // assert
      await expectLater(authStateStream, emits(false));
    });

    test('should emit user state null', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });
      await authCore.initialize();

      // act
      final userStateStream = authCore.userChanges();
      authCore.logout();

      // assert
      await expectLater(userStateStream, emits(isNull));
    });
  });

  group('getCurrentUser', () {
    test('should return cached user when available', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});
      await authCore.setUser(tUser, tToken);

      // act
      final user = await authCore.getCurrentUser();

      // assert
      expect(user, isNotNull);
      expect(user?.id, tUser.id);
      expect(user?.email, tUser.email);
    });

    test('should load user from storage when not cached', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });

      // act (without initialize, so user is not cached)
      final user = await authCore.getCurrentUser();

      // assert
      expect(user, isNotNull);
      expect(user?.email, tUser.email);
    });

    test('should return null when no user exists', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      final user = await authCore.getCurrentUser();

      // assert
      expect(user, isNull);
    });

    test('should clear storage and return null when user data is invalid', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': 'invalid_json',
      });

      // act
      final user = await authCore.getCurrentUser();
      final prefs = await SharedPreferences.getInstance();

      // assert
      expect(user, isNull);
      expect(prefs.getString('user_data'), isNull);
    });
  });

  group('getToken', () {
    test('should return cached token when available', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});
      await authCore.setUser(tUser, tToken);

      // act
      final token = await authCore.getToken();

      // assert
      expect(token, tToken);
    });

    test('should load token from storage when not cached', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'auth_token': tToken,
      });

      // act (without initialize, so token is not cached)
      final token = await authCore.getToken();

      // assert
      expect(token, tToken);
    });

    test('should return null when no token exists', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      final token = await authCore.getToken();

      // assert
      expect(token, isNull);
    });
  });

  group('isAuthenticated', () {
    test('should return true when token exists', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'auth_token': tToken,
      });

      // act
      final isAuth = await authCore.isAuthenticated();

      // assert
      expect(isAuth, true);
    });

    test('should return false when no token exists', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});

      // act
      final isAuth = await authCore.isAuthenticated();

      // assert
      expect(isAuth, false);
    });

    test('should return false after logout', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'user_data': jsonEncode(tUser.toJson()),
        'auth_token': tToken,
      });
      await authCore.initialize();

      // act
      await authCore.logout();
      final isAuth = await authCore.isAuthenticated();

      // assert
      expect(isAuth, false);
    });
  });

  group('streams', () {
    test('should emit multiple auth state changes', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});
      final authStateStream = authCore.authChanges();

      // act & assert
      authCore.setUser(tUser, tToken);
      await expectLater(authStateStream, emits(true));

      authCore.logout();
      await expectLater(authStateStream, emits(false));
    });

    test('should emit multiple user state changes', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});
      final userStateStream = authCore.userChanges();

      // act & assert
      authCore.setUser(tUser, tToken);
      await expectLater(
        userStateStream,
        emits(predicate<UserModel>((user) => user.email == tUser.email)),
      );

      authCore.logout();
      await expectLater(userStateStream, emits(isNull));
    });
  });
}