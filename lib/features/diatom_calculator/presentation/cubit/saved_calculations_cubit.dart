import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/saved_calculation.dart';
import '../../domain/repositories/diatom_calculator_repository.dart';

part 'saved_calculations_state.dart';

/// The readings this device has saved, on their own screen.
class SavedCalculationsCubit extends Cubit<SavedCalculationsState> {
  final DiatomCalculatorRepository _repository;

  SavedCalculationsCubit(this._repository) : super(SavedCalculationsInitial());

  Future<void> load() async {
    emit(SavedCalculationsLoading());

    final result = await _repository.getSavedCalculations();

    switch (result) {
      case Success<List<SavedCalculation>>():
        emit(SavedCalculationsLoaded(result.value));
      case Failure<List<SavedCalculation>>():
        emit(SavedCalculationsError(result.message));
    }
  }

  /// Removes a reading, putting it back in the list if the server refused.
  Future<String?> delete(int id) async {
    final current = state;
    if (current is! SavedCalculationsLoaded) return null;

    emit(
      SavedCalculationsLoaded(
        current.calculations.where((c) => c.id != id).toList(),
      ),
    );

    final result = await _repository.deleteCalculation(id);
    if (result.isFailure) {
      emit(current);
      return result.errorMessage;
    }
    return null;
  }
}
