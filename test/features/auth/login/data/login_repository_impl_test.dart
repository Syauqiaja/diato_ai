import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/login/data/login_repository_impl.dart';
import 'package:diato_ai/features/auth/login/domain/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockAuthCore extends Mock implements AuthCore {}

void main() {
  late Dio dio;
  late AuthCore authCore;
  late LoginRepositoryImpl loginRepository;
  late FirebaseAuth firebaseAuth;

  setUp((){
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

  
}