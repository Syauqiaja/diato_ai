import 'package:diato_ai/core/data/result.dart';

import '../../data/models/content_detail.dart';
import '../../data/models/content_item.dart';
import '../../data/models/content_search_result.dart';
import '../../data/models/content_type.dart';

abstract class ContentRepository {
  /// One list, in the order the console set.
  Future<Result<List<ContentItem>>> getContents(ContentType type);

  /// One entry, body included.
  Future<Result<ContentDetail>> getContentDetail(int contentId);

  /// Every type at once, title hits first.
  Future<Result<List<ContentSearchResult>>> search(String query);
}
