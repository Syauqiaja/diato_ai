import 'package:diato_ai/core/data/result.dart';

abstract class Usecase<T, Params> {
  Future<Result<T>> call(Params params);
}