import 'package:diato_ai/core/data/result.dart';

import '../../data/models/species_detail.dart';
import '../../data/models/species_summary.dart';

abstract class SpeciesRepository {
  /// The catalogue, ordered by name.
  Future<Result<List<SpeciesSummary>>> getSpecies({String? query});

  /// One catalogue species, explanation included.
  Future<Result<SpeciesDetail>> getSpeciesDetail(int speciesId);
}
