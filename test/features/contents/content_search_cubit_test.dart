import 'dart:async';

import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/contents/data/models/content_detail.dart';
import 'package:diato_ai/features/contents/data/models/content_item.dart';
import 'package:diato_ai/features/contents/data/models/content_search_result.dart';
import 'package:diato_ai/features/contents/data/models/content_type.dart';
import 'package:diato_ai/features/contents/domain/repositories/content_repository.dart';
import 'package:diato_ai/features/contents/presentation/cubit/content_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers each query when the test completes its completer.
class _ManualRepository extends ContentRepository {
  final pending = <String, Completer<Result<List<ContentSearchResult>>>>{};

  @override
  Future<Result<List<ContentSearchResult>>> search(String query) =>
      (pending[query] = Completer()).future;

  void answer(String query) => pending[query]!.complete(Result.success([
        ContentSearchResult(id: 1, type: ContentType.family, title: query, matchedInTitle: true),
      ]));

  @override
  Future<Result<List<ContentItem>>> getContents(ContentType type) => throw UnimplementedError();

  @override
  Future<Result<ContentDetail>> getContentDetail(int contentId) => throw UnimplementedError();
}

void main() {
  test('a slow answer to an older query does not replace the newer one', () async {
    final repository = _ManualRepository();
    final cubit = ContentSearchCubit(repository);

    final first = cubit.search('nav');
    final second = cubit.search('navicula');

    repository.answer('navicula');
    await second;
    repository.answer('nav');
    await first;

    final state = cubit.state as ContentSearchData;
    expect(state.query, 'navicula');
    expect(state.results.single.title, 'navicula');
  });

  test('clearing the query goes back to idle', () async {
    final cubit = ContentSearchCubit(_ManualRepository());

    await cubit.search('   ');

    expect(cubit.state, isA<ContentSearchIdle>());
  });
}
