import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/group_challenge_repository_interface.dart';
import 'group_challenge_event.dart';
import 'group_challenge_state.dart';

class GroupChallengeBloc
    extends Bloc<GroupChallengeEvent, GroupChallengeState> {
  final GroupChallengeRepositoryInterface repository;

  GroupChallengeBloc({required this.repository})
      : super(const GroupChallengeState()) {
    on<LoadCurrentEventsEvent>(_onLoadCurrentEvents);
    on<LoadEndedEventsEvent>(_onLoadEndedEvents);
    on<LoadUpcomingEventsEvent>(_onLoadUpcomingEvents);
    on<LoadMyEventsEvent>(_onLoadMyEvents);
    on<RegisterForEventEvent>(_onRegisterForEvent);
    on<LoadEventWinnersEvent>(_onLoadEventWinners);
    on<RecordBookQuizResultEvent>(_onRecordBookQuizResult);
  }

  Future<void> _loadCurrent(Emitter<GroupChallengeState> emit) async {
    emit(state.copyWith(isLoadingCurrent: true, currentError: null));
    final result = await repository.getCurrentEvents();
    result.fold(
      (error) => emit(state.copyWith(isLoadingCurrent: false, currentError: error)),
      (events) => emit(state.copyWith(isLoadingCurrent: false, currentEvents: events)),
    );
  }

  Future<void> _loadEnded(Emitter<GroupChallengeState> emit) async {
    emit(state.copyWith(isLoadingEnded: true, endedError: null));
    final result = await repository.getEndedEvents();
    result.fold(
      (error) => emit(state.copyWith(isLoadingEnded: false, endedError: error)),
      (events) => emit(state.copyWith(isLoadingEnded: false, endedEvents: events)),
    );
  }

  Future<void> _loadUpcoming(Emitter<GroupChallengeState> emit) async {
    emit(state.copyWith(isLoadingUpcoming: true, upcomingError: null));
    final result = await repository.getUpcomingEvents();
    result.fold(
      (error) => emit(state.copyWith(isLoadingUpcoming: false, upcomingError: error)),
      (events) => emit(state.copyWith(isLoadingUpcoming: false, upcomingEvents: events)),
    );
  }

  Future<void> _loadMy(Emitter<GroupChallengeState> emit) async {
    emit(state.copyWith(isLoadingMy: true, myError: null));
    final result = await repository.getMyEvents();
    result.fold(
      (error) => emit(state.copyWith(isLoadingMy: false, myError: error)),
      (events) => emit(state.copyWith(isLoadingMy: false, myEvents: events)),
    );
  }

  Future<void> _onLoadCurrentEvents(
    LoadCurrentEventsEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    await _loadCurrent(emit);
  }

  Future<void> _onLoadEndedEvents(
    LoadEndedEventsEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    await _loadEnded(emit);
  }

  Future<void> _onLoadUpcomingEvents(
    LoadUpcomingEventsEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    await _loadUpcoming(emit);
  }

  Future<void> _onLoadMyEvents(
    LoadMyEventsEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    await _loadMy(emit);
  }

  Future<void> _onRegisterForEvent(
    RegisterForEventEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    final result =
        await repository.registerForEvent(eventId: event.eventId);
    await result.fold(
      (error) async => emit(state.copyWith(actionError: error)),
      (_) async {
        await _loadCurrent(emit);
        await _loadUpcoming(emit);
      },
    );
  }

  Future<void> _onLoadEventWinners(
    LoadEventWinnersEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    final result = await repository.getWinners(eventId: event.eventId);
    result.fold(
      (error) => emit(state.copyWith(actionError: error)),
      (winners) => emit(state.copyWith(
        winnersByEventId: {...state.winnersByEventId, event.eventId: winners},
      )),
    );
  }

  Future<void> _onRecordBookQuizResult(
    RecordBookQuizResultEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    final result = await repository.recordBookQuizResult(
      bookId: event.bookId,
      passed: event.passed,
    );
    await result.fold(
      (error) async => emit(state.copyWith(actionError: error)),
      (updatedList) async {
        emit(state.copyWith(currentEvents: updatedList));
        await _loadMy(emit);
      },
    );
  }
}