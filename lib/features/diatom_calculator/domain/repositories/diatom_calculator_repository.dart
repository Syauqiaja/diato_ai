import 'package:diato_ai/core/data/result.dart';

import '../../data/models/catalogue_species.dart';
import '../../data/models/saved_calculation.dart';
import '../brdi_calculator.dart';

abstract class DiatomCalculatorRepository {
  /// The catalogue of species that can be counted, scored and unscored alike.
  Future<Result<List<CatalogueSpecies>>> getCatalogue();

  /// Readings previously saved from this device, newest first.
  Future<Result<List<SavedCalculation>>> getSavedCalculations();

  /// Stores a reading worked out on the device.
  Future<Result<SavedCalculation>> saveCalculation({
    required String? location,
    required BrdiResult result,
    required List<SpeciesEntry> entries,
  });

  Future<Result<void>> deleteCalculation(int id);
}
