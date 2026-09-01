import 'dart:convert';

import 'package:diato_ai/features/shared/models/station.dart';
import 'package:diato_ai/features/shared/models/station_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Station.fromJson parses the /api/stations payload', () {
    const payload = '''
    {"id":1,"title":"Test Stasiun Pertama","description":"The next description",
     "latitude":-7.97762913,"longitude":112.64209726,
     "image":"/storage/stations/abc.jpg","species_count":2,
     "created_at":"2026-03-05T16:27:01.000000Z","updated_at":"2026-03-05T16:27:01.000000Z"}
    ''';

    final station = Station.fromJson(jsonDecode(payload) as Map<String, dynamic>);

    expect(station.id, 1);
    expect(station.title, 'Test Stasiun Pertama');
    expect(station.latitude, closeTo(-7.97762913, 1e-9));
    expect(station.longitude, closeTo(112.64209726, 1e-9));
    expect(station.speciesCount, 2);
    expect(station.imageUrl, 'https://diato-ai.fajrsyauqi.com/storage/stations/abc.jpg');
  });

  test('Station.fromJson tolerates a null image and integer coordinates', () {
    final station = Station.fromJson({
      'id': 2,
      'title': 'Tanpa Gambar',
      'description': null,
      'latitude': -7,
      'longitude': 112,
      'image': null,
    });

    expect(station.imageUrl, isNull);
    expect(station.description, '');
    expect(station.latitude, -7.0);
    expect(station.speciesCount, 0);
  });

  test('StationDetail.fromJson parses found species and totals', () {
    const payload = '''
    {"id":1,"title":"Test Stasiun Pertama","description":"<p>html</p>",
     "latitude":-7.97762913,"longitude":112.64209726,
     "image":"/storage/stations/abc.jpg",
     "found_species":[{"id":1,"name":"Ditto 1","count":9},{"id":2,"name":"Diato 2","count":12}],
     "total_species_count":2,"total_individuals_count":21}
    ''';

    final detail = StationDetail.fromJson(jsonDecode(payload) as Map<String, dynamic>);

    expect(detail.foundSpecies, hasLength(2));
    expect(detail.foundSpecies.first.name, 'Ditto 1');
    expect(detail.foundSpecies.last.count, 12);
    expect(detail.totalSpeciesCount, 2);
    expect(detail.totalIndividualsCount, 21);
    expect(detail.description, '<p>html</p>');
  });

  test('StationDetail.fromJson handles a missing found_species key', () {
    final detail = StationDetail.fromJson({
      'id': 3,
      'title': 'Kosong',
      'description': '',
      'latitude': 0,
      'longitude': 0,
      'image': null,
    });

    expect(detail.foundSpecies, isEmpty);
    expect(detail.totalIndividualsCount, 0);
  });
}
