import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/interests_repository_interface.dart';
import 'interests_event.dart';
import 'interests_state.dart';

class InterestsBloc extends Bloc<InterestsEvent, InterestsState> {
  final InterestsRepositoryInterface repository;

  InterestsBloc({required this.repository}) : super(const InterestsInitial()) {
    on<LoadInterestsEvent>(_onLoadInterests);
    on<ToggleInterestEvent>(_onToggleInterest);
    on<SaveInterestsEvent>(_onSaveInterests);
  }

  Future<void> _onLoadInterests(
    LoadInterestsEvent event,
    Emitter<InterestsState> emit,
  ) async {
    emit(const InterestsLoading());

    final result = await repository.getAllInterests();
    result.fold(
      (error) => emit(InterestsError(message: error)),
      (interests) {
        final selectedIds = <int>{...event.selectedInterestIds};
        final marked = interests
            .map((i) => i.copyWith(isSelected: selectedIds.contains(i.id)))
            .toList();
        emit(InterestsLoaded(interests: marked));
      },
    );
  }

  void _onToggleInterest(
    ToggleInterestEvent event,
    Emitter<InterestsState> emit,
  ) {
    final current = state;
    if (current is! InterestsLoaded) return;

    final updated = current.interests.map((interest) {
      if (interest.id == event.interestId) {
        return interest.copyWith(isSelected: !interest.isSelected);
      }
      return interest;
    }).toList();

    emit(InterestsLoaded(interests: updated));
  }

  Future<void> _onSaveInterests(
    SaveInterestsEvent event,
    Emitter<InterestsState> emit,
  ) async {
    final current = state;
    if (current is! InterestsLoaded) return;

    emit(InterestsSaving(interests: current.interests));

    final result = await repository.updateUserInterests(event.selectedInterestIds);
    result.fold(
      (error) => emit(InterestsError(message: error)),
      (interests) => emit(InterestsSaveSuccess(interests: interests)),
    );
  }
}