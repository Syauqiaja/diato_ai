import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/content_search_result.dart';
import '../../domain/repositories/content_repository.dart';

part 'content_search_state.dart';

/// Search across courses, guides and families. Typing fires requests faster
/// than they come back, so only the answer to the latest query is kept.
class ContentSearchCubit extends Cubit<ContentSearchState> {
  final ContentRepository contentRepository;
  String _latest = '';

  ContentSearchCubit(this.contentRepository) : super(ContentSearchIdle());

  Future<void> search(String query) async {
    final trimmed = query.trim();
    _latest = trimmed;

    if (trimmed.isEmpty) {
      emit(ContentSearchIdle());
      return;
    }

    emit(ContentSearchLoading(trimmed));
    final result = await contentRepository.search(trimmed);
    if (trimmed != _latest || isClosed) return;

    result.when(
      success: (results) => emit(ContentSearchData(trimmed, results)),
      failure: (message) => emit(ContentSearchError(trimmed, message)),
    );
  }

  void clear() => search('');
}
