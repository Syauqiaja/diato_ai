import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/shared/models/guide_detail.dart';
import 'package:diato_ai/features/shared/models/guide_item.dart';

abstract class GuideRepository {
  /// The guides, in the order the console set.
  Future<Result<List<GuideItem>>> getGuides();

  /// One guide, content included.
  Future<Result<GuideDetail>> getGuideDetail(int guideId);
}
