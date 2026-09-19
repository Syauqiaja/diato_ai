import 'package:diato_ai/core/data/result.dart';

import '../../data/models/species_detail.dart';

abstract class SpeciesRepository {
  /// One catalogue species.
  Future<Result<SpeciesDetail>> getSpeciesDetail(int speciesId);
}
