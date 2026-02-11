import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/register/data/register_repository_impl.dart';
import 'package:diato_ai/features/auth/register/domain/register_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockAuthCore extends Mock implements AuthCore {}

void main() {
  late RegisterRepositoryImpl registerRepository;
  late Dio mockDio;
  late AuthCore mockAuthCore;

  setUp((){
    mockDio = MockDio();
    mockAuthCore = MockAuthCore();
    registerRepository = RegisterRepositoryImpl(mockDio, mockAuthCore);
  });

  group('register repository', () {
    test('should have RegisterRepositoryImpl extends RegisterRepository', () { 
      expect(registerRepository, isA<RegisterRepository>());
     });
  });
}