import 'package:equatable/equatable.dart';

import '../data/models/catalogue_species.dart';

/// One species counted at a sampling point.
class SpeciesEntry extends Equatable {
  final CatalogueSpecies species;
  final int count;

  const SpeciesEntry({required this.species, required this.count});

  SpeciesEntry copyWith({int? count}) {
    return SpeciesEntry(species: species, count: count ?? this.count);
  }

  @override
  List<Object?> get props => [species, count];
}

/// How much one species pushed the index, kept so the result can be explained.
class BrdiContribution extends Equatable {
  final CatalogueSpecies species;
  final int count;
  final int sensitivity;
  final int indicator;

  const BrdiContribution({
    required this.species,
    required this.count,
    required this.sensitivity,
    required this.indicator,
  });

  /// The abundance weight this species carries: how many were found, scaled by
  /// how strongly the species indicates anything at all.
  int get weight => count * indicator;

  /// The species' share of the numerator, before it is divided by the weights.
  int get score => weight * sensitivity;

  @override
  List<Object?> get props => [species, count, sensitivity, indicator];
}

/// The five water quality bands the index falls into.
enum BrdiCategory {
  sangatBuruk('sangat_buruk', 'Sangat buruk'),
  buruk('buruk', 'Buruk'),
  sedang('sedang', 'Sedang'),
  baik('baik', 'Baik'),
  sangatBaik('sangat_baik', 'Sangat baik');

  /// The value stored on the server, kept stable when the label changes.
  final String value;
  final String label;

  const BrdiCategory(this.value, this.label);

  /// The band [di] falls into. Each boundary starts the higher band.
  static BrdiCategory forIndex(double di) {
    if (di < 1.5) return BrdiCategory.sangatBuruk;
    if (di < 2.5) return BrdiCategory.buruk;
    if (di < 3.5) return BrdiCategory.sedang;
    if (di < 4.5) return BrdiCategory.baik;
    return BrdiCategory.sangatBaik;
  }

  /// Reads a stored value back, or null when the server sent something this
  /// build does not know about.
  static BrdiCategory? fromValue(String? value) {
    for (final category in BrdiCategory.values) {
      if (category.value == value) return category;
    }
    return null;
  }
}

/// The index for one set of counts, with the per-species breakdown behind it.
class BrdiResult extends Equatable {
  /// Null when nothing scoreable was entered, so there is no index to show.
  final double? di;
  final List<BrdiContribution> contributions;

  const BrdiResult({required this.di, required this.contributions});

  BrdiCategory? get category => di == null ? null : BrdiCategory.forIndex(di!);

  /// Total of every contribution's score, for drawing relative shares.
  int get totalScore =>
      contributions.fold(0, (sum, contribution) => sum + contribution.score);

  @override
  List<Object?> get props => [di, contributions];
}

/// The Brantas River Diatom Index, computed on the device.
///
///     DI = Σ(count × indicator × sensitivity) / Σ(count × indicator)
///
/// Species missing either score, or counted zero times, carry no weight and
/// are left out of both sums rather than being treated as a zero — averaging
/// them in would drag the index toward the worst band for no reason.
class BrdiCalculator {
  const BrdiCalculator._();

  static BrdiResult calculate(List<SpeciesEntry> entries) {
    final contributions = <BrdiContribution>[];

    for (final entry in entries) {
      final sensitivity = entry.species.sensitivity;
      final indicator = entry.species.indicator;
      if (sensitivity == null || indicator == null || entry.count <= 0) {
        continue;
      }
      contributions.add(
        BrdiContribution(
          species: entry.species,
          count: entry.count,
          sensitivity: sensitivity,
          indicator: indicator,
        ),
      );
    }

    var numerator = 0;
    var denominator = 0;
    for (final contribution in contributions) {
      numerator += contribution.score;
      denominator += contribution.weight;
    }

    return BrdiResult(
      di: denominator > 0 ? numerator / denominator : null,
      contributions: contributions,
    );
  }
}
