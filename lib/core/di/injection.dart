import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:diato_ai/features/auth/login/data/login_repository.dart';
import 'package:diato_ai/features/auth/register/data/register_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  getIt.registerSingleton<LoginRepository>(LoginRepository());
  getIt.registerSingleton<RegisterRepository>(RegisterRepository());
  getIt.registerSingleton<AuthCore>(AuthCore());
}