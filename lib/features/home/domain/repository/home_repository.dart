import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/shared/models/article.dart';


abstract class HomeRepository  {
  Future<Result<List<Article>>> getArticles();
}