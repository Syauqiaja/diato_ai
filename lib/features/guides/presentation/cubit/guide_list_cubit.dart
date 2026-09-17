import 'package:bloc/bloc.dart';
import 'package:diato_ai/features/guides/domain/repositories/guide_repository.dart';
import 'package:diato_ai/features/shared/models/guide_item.dart';
import 'package:equatable/equatable.dart';

part 'guide_list_state.dart';

class GuideListCubit extends Cubit<GuideListState> {
  final GuideRepository guideRepository;

  GuideListCubit(this.guideRepository) : super(GuideListInitial());

  Future<void> fetchGuides() async {
    emit(GuideListLoading());
    final result = await guideRepository.getGuides();

    result.when(
      success: (guides) => emit(GuideListData(guides)),
      failure: (message) => emit(GuideListError(message)),
    );
  }
}
