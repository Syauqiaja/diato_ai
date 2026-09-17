import 'package:diato_ai/features/shared/models/guide_detail.dart';
import 'package:diato_ai/features/shared/models/guide_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GuideItem', () {
    test('parses a row from /api/guides', () {
      final guide = GuideItem.fromJson({
        'id': 1,
        'title': 'Prosedur Pengambilan Diatom',
        'cover': '/storage/guides/a.jpg',
        'order': 1,
      });

      expect(guide.id, 1);
      expect(guide.title, 'Prosedur Pengambilan Diatom');
      expect(guide.cover, contains('/storage/guides/a.jpg'));
    });

    test('a guide without a cover has none to load', () {
      final guide = GuideItem.fromJson({'id': 2, 'title': 'Prosedur Identifikasi Diatom', 'cover': null});

      expect(guide.cover, isNull);
    });
  });

  group('GuideDetail', () {
    test('parses the content sent by /api/guides/{id}', () {
      final detail = GuideDetail.fromJson({
        'id': 2,
        'title': 'Prosedur Identifikasi Diatom',
        'cover': null,
        'content': '<h2>a. Alat dan Bahan</h2>',
        'order': 2,
      });

      expect(detail.title, 'Prosedur Identifikasi Diatom');
      expect(detail.cover, isNull);
      expect(detail.content, '<h2>a. Alat dan Bahan</h2>');
    });
  });
}
