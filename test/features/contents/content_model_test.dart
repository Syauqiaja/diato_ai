import 'package:diato_ai/features/contents/data/models/content_detail.dart';
import 'package:diato_ai/features/contents/data/models/content_item.dart';
import 'package:diato_ai/features/contents/data/models/content_search_result.dart';
import 'package:diato_ai/features/contents/data/models/content_type.dart';
import 'package:diato_ai/features/contents/presentation/widgets/highlighted_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContentItem', () {
    test('parses a row from /api/contents', () {
      final item = ContentItem.fromJson({
        'id': 11,
        'type': 'family',
        'title': 'FAMILI NAVICULACEAE',
        'cover': '/storage/families/a.jpg',
        'order': 1,
      });

      expect(item.id, 11);
      expect(item.type, ContentType.family);
      expect(item.cover, contains('/storage/families/a.jpg'));
    });

    test('an entry without a cover has none to load', () {
      final item = ContentItem.fromJson({'id': 2, 'type': 'guide', 'title': 'Prosedur', 'cover': null});

      expect(item.type, ContentType.guide);
      expect(item.cover, isNull);
    });
  });

  test('ContentDetail parses the body sent by /api/contents/{id}', () {
    final detail = ContentDetail.fromJson({
      'id': 2,
      'type': 'course',
      'title': 'Mengenal Diatom',
      'cover': 'https://example.com/a.jpg',
      'content': '<h2>a. Alat dan Bahan</h2>',
    });

    expect(detail.type, ContentType.course);
    expect(detail.cover, 'https://example.com/a.jpg');
    expect(detail.content, '<h2>a. Alat dan Bahan</h2>');
  });

  test('ContentSearchResult says where the query matched', () {
    final title = ContentSearchResult.fromJson({
      'id': 1,
      'type': 'family',
      'title': 'FAMILI NAVICULACEAE',
      'cover': null,
      'matched_in': 'title',
      'snippet': 'Ciri',
    });
    final body = ContentSearchResult.fromJson({
      'id': 2,
      'type': 'course',
      'title': 'Mengenal Diatom',
      'cover': null,
      'matched_in': 'content',
      'snippet': 'Tentang Navicula di sungai.',
    });

    expect(title.matchedInTitle, isTrue);
    expect(body.matchedInTitle, isFalse);
    expect(body.snippet, 'Tentang Navicula di sungai.');
  });

  group('highlightSpans', () {
    const bold = TextStyle(fontWeight: FontWeight.bold);

    test('picks out every match regardless of case', () {
      final spans = highlightSpans('Navicula dan navicula', 'NAVI', bold);

      expect(spans.map((s) => s.text).toList(), ['Navi', 'cula dan ', 'navi', 'cula']);
      expect(spans.where((s) => s.style == bold).length, 2);
    });

    test('an empty query leaves the text alone', () {
      final spans = highlightSpans('Navicula', '  ', bold);

      expect(spans.single.text, 'Navicula');
      expect(spans.single.style, isNull);
    });
  });
}
