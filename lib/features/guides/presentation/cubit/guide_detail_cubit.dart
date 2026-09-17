import 'package:bloc/bloc.dart';
import 'package:diato_ai/features/guides/domain/repositories/guide_repository.dart';
import 'package:diato_ai/features/shared/models/guide_detail.dart';
import 'package:equatable/equatable.dart';

part 'guide_detail_state.dart';

class GuideDetailCubit extends Cubit<GuideDetailState> {
  final GuideRepository guideRepository;

  GuideDetailCubit(this.guideRepository) : super(GuideDetailInitial());

  Future<void> fetchGuideDetail(int guideId) async {
    emit(GuideDetailLoading());
    final result = await guideRepository.getGuideDetail(guideId);

    result.when(
      success: (guideDetail) => emit(GuideDetailData(guideDetail)),
      failure: (message) => emit(GuideDetailError(message)),
    );
  }
}
