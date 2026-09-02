part of 'saved_calculations_cubit.dart';

sealed class SavedCalculationsState extends Equatable {
  const SavedCalculationsState();

  @override
  List<Object> get props => [];
}

final class SavedCalculationsInitial extends SavedCalculationsState {}

final class SavedCalculationsLoading extends SavedCalculationsState {}

final class SavedCalculationsLoaded extends SavedCalculationsState {
  final List<SavedCalculation> calculations;

  const SavedCalculationsLoaded(this.calculations);

  @override
  List<Object> get props => [calculations];
}

final class SavedCalculationsError extends SavedCalculationsState {
  final String message;

  const SavedCalculationsError(this.message);

  @override
  List<Object> get props => [message];
}
