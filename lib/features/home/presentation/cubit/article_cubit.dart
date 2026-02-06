import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/di/injection.dart';
import 'package:diato_ai/features/home/repository/home_repository.dart';
import 'package:diato_ai/features/shared/models/article.dart';
import 'package:equatable/equatable.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final HomeRepository _homeRepository;

  ArticleCubit({HomeRepository? homeRepository})
      : _homeRepository = homeRepository ?? getIt<HomeRepository>(),
        super(ArticleInitial());

  /// Fetch all articles
  Future<void> getArticles() async {
    emit(ArticleLoading());

    try {
      final result = await _homeRepository.getArticles();

      switch (result) {
        case Success<List<Article>>():
          emit(ArticleLoaded(result.data));
        case Failure<List<Article>>():
          emit(ArticleError(result.message));
      }
    } catch (e) {
      emit(ArticleError('An unexpected error occurred: $e'));
    }
  }
}
