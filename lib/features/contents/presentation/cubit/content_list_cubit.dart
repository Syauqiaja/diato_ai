import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/content_item.dart';
import '../../data/models/content_type.dart';
import '../../domain/repositories/content_repository.dart';

part 'content_list_state.dart';

/// The course, guide and family lists, each loaded and failing on its own.
class ContentListCubit extends Cubit<ContentListState> {
  final ContentRepository contentRepository;

  ContentListCubit(this.contentRepository) : super(const ContentListState());

  Future<void> fetchAll() => Future.wait(ContentType.values.map(fetch));

  Future<void> fetch(ContentType type) async {
    emit(state.withSection(type, const ContentSection(status: ContentListStatus.loading)));
    final result = await contentRepository.getContents(type);

    result.when(
      success: (items) => emit(state.withSection(
        type,
        ContentSection(status: ContentListStatus.loaded, items: items),
      )),
      failure: (message) => emit(state.withSection(
        type,
        ContentSection(status: ContentListStatus.error, error: message),
      )),
    );
  }
}
