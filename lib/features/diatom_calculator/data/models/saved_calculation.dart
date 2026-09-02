import 'package:equatable/equatable.dart';

import '../../domain/brdi_calculator.dart';

/// One species as it was counted in a saved reading.
///
/// The name and scores are the values from the moment it was saved, not a live
/// read of the catalogue: editing a species in the console must not change what
/// an old reading says was found.
class SavedCalculationEntry extends Equatable {
  final int? speciesId;
  final String speciesName;
  final int count;
  final int? sensitivity;
  final int? indicator;

  const SavedCalculationEntry({
    required this.speciesId,
    required this.speciesName,
    required this.count,
    this.sensitivity,
    this.indicator,
  });

  bool get isScored => sensitivity != null && indicator != null;

  factory SavedCalculationEntry.fromJson(Map<String, dynamic> json) {
    return SavedCalculationEntry(
      speciesId: (json['species_id'] as num?)?.toInt(),
      speciesName: json['species_name'] as String,
      count: (json['count'] as num).toInt(),
      sensitivity: (json['sensitivity'] as num?)?.toInt(),
      indicator: (json['indicator'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'species_id': speciesId,
      'species_name': speciesName,
      'count': count,
      'sensitivity': sensitivity,
      'indicator': indicator,
    };
  }

  @override
  List<Object?> get props => [speciesId, speciesName, count, sensitivity, indicator];
}

/// A water quality reading kept on the server for this device.
class SavedCalculation extends Equatable {
  final int id;
  final String? location;
  final double di;
  final BrdiCategory? category;
  final DateTime? createdAt;
  final List<SavedCalculationEntry> entries;

  const SavedCalculation({
    required this.id,
    required this.location,
    required this.di,
    required this.category,
    required this.createdAt,
    required this.entries,
  });

  factory SavedCalculation.fromJson(Map<String, dynamic> json) {
    final entries = (json['entries'] as List<dynamic>? ?? [])
        .map((e) => SavedCalculationEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    return SavedCalculation(
      id: (json['id'] as num).toInt(),
      location: json['location'] as String?,
      di: (json['di'] as num).toDouble(),
      // Fall back to the band the index itself lands in, so a value this build
      // does not recognise still shows something sensible.
      category: BrdiCategory.fromValue(json['category'] as String?) ??
          BrdiCategory.forIndex((json['di'] as num).toDouble()),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      entries: entries,
    );
  }

  @override
  List<Object?> get props => [id, location, di, category, createdAt, entries];
}
