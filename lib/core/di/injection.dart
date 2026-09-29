import 'package:diato_ai/core/data/dio_client.dart';
import 'package:diato_ai/core/device/device_installation_id.dart';
import 'package:diato_ai/features/contents/data/repositories/content_repository_impl.dart';
import 'package:diato_ai/features/contents/domain/repositories/content_repository.dart';
import 'package:diato_ai/features/diatom_calculator/data/repositories/diatom_calculator_repository_impl.dart';
import 'package:diato_ai/features/diatom_calculator/domain/repositories/diatom_calculator_repository.dart';
import 'package:diato_ai/features/home/data/repositories/home_repository_impl.dart';
import 'package:diato_ai/features/map/data/repositories/station_repository_impl.dart';
import 'package:diato_ai/features/map/domain/repositories/station_repository.dart';
import 'package:diato_ai/features/scanner/data/repositories/scanner_repository_impl.dart';
import 'package:diato_ai/features/scanner/domain/repositories/scanner_repository.dart';
import 'package:diato_ai/features/species/data/repositories/species_repository_impl.dart';
import 'package:diato_ai/features/species/domain/repositories/species_repository.dart';
import 'package:diato_ai/features/home/domain/repository/home_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  getIt.registerSingleton<DeviceInstallationId>(DeviceInstallationId());
  getIt.registerSingleton<Dio>(DioClient.instance);
  getIt.registerSingleton<HomeRepository>(HomeRepositoryImpl(getIt()));
  getIt.registerSingleton<ContentRepository>(ContentRepositoryImpl(getIt()));
  getIt.registerSingleton<StationRepository>(StationRepositoryImpl(getIt()));
  getIt.registerSingleton<ScannerRepository>(ScannerRepositoryImpl(getIt()));
  getIt.registerSingleton<DiatomCalculatorRepository>(
    DiatomCalculatorRepositoryImpl(getIt()),
  );
  getIt.registerSingleton<SpeciesRepository>(SpeciesRepositoryImpl(getIt()));
}
