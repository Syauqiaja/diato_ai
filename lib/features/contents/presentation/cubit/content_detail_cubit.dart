import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/content_detail.dart';
import '../../domain/repositories/content_repository.dart';

part 'content_detail_state.dart';

class ContentDetailCubit extends Cubit<ContentDetailState> {
  final ContentRepository contentRepository;

  ContentDetailCubit(this.contentRepository) : super(ContentDetailInitial());

  Future<void> fetchContentDetail(int contentId) async {
    emit(ContentDetailLoading());
    final result = await contentRepository.getContentDetail(contentId);

    result.when(
      success: (detail) => emit(ContentDetailData(detail)),
      failure: (message) => emit(ContentDetailError(message)),
    );
  }
}
