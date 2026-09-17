import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/guides/domain/repositories/guide_repository.dart';
import 'package:diato_ai/features/shared/models/guide_detail.dart';
import 'package:diato_ai/features/shared/models/guide_item.dart';
import 'package:dio/dio.dart';

final class GuideRepositoryImpl extends GuideRepository {
  final Dio dio;

  GuideRepositoryImpl(this.dio);

  @override
  Future<Result<List<GuideItem>>> getGuides() async {
    try {
      final response = await dio.get('/guides');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        final guides = data.map((json) => GuideItem.fromJson(json as Map<String, dynamic>)).toList();
        return Result.success(guides);
      } else {
        return Result.failure(response.data['message'] ?? 'Failed to fetch guides');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        return Result.failure(message ?? 'An error occurred');
      } else {
        return Result.failure('Network error: ${e.message}');
      }
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<GuideDetail>> getGuideDetail(int guideId) async {
    try {
      final response = await dio.get('/guides/$guideId');

      if (response.statusCode == 200) {
        final guideDetail = GuideDetail.fromJson(response.data['data'] as Map<String, dynamic>);
        return Result.success(guideDetail);
      } else {
        return Result.failure(response.data['message'] ?? 'Failed to fetch guide detail');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        return Result.failure(message ?? 'An error occurred');
      } else {
        return Result.failure('Network error: ${e.message}');
      }
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }
}
