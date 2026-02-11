import 'package:diato_ai/core/data/dio_client.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/login/data/login_repository_impl.dart';
import 'package:diato_ai/features/auth/register/data/register_repository_impl.dart';
import 'package:diato_ai/features/home/data/repositories/home_repository_impl.dart';
import 'package:diato_ai/features/home/domain/repository/home_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/login/domain/login_repository.dart';
import '../../features/auth/register/domain/register_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  getIt.registerSingleton<Dio>(DioClient.instance);
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<AuthCore>(AuthCore(getIt()));

  getIt.registerSingleton<LoginRepository>(LoginRepositoryImpl(getIt(), getIt(), getIt()));
  getIt.registerSingleton<RegisterRepository>(RegisterRepositoryImpl(getIt(), getIt()));
  getIt.registerSingleton<HomeRepository>(HomeRepositoryImpl(getIt()));
}
