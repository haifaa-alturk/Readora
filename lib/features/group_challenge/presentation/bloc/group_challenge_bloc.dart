import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/group_challenge_entity.dart';
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
    on<LoadCancelledEventsEvent>(_onLoadCancelledEvents);
    on<RegisterForEventEvent>(_onRegisterForEvent);
    on<CancelParticipationEvent>(_onCancelParticipation);
    on<LoadEventWinnersEvent>(_onLoadEventWinners);
    on<LoadEventDetailEvent>(_onLoadEventDetail);
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

  Future<void> _onLoadCancelledEvents(
    LoadCancelledEventsEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    emit(state.copyWith(isLoadingCancelled: true, cancelledError: null));
    final result = await repository.getCancelledEvents();
    result.fold(
      (error) => emit(state.copyWith(
        isLoadingCancelled: false,
        cancelledError: error,
      )),
      (events) => emit(state.copyWith(
        isLoadingCancelled: false,
        cancelledEvents: events,
      )),
    );
  }

  Future<void> _onRegisterForEvent(
    RegisterForEventEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    final result =
        await repository.registerForEvent(eventId: event.eventId);
    GroupChallengeEntity? registered;
    result.fold(
      (error) => null,
      (value) => registered = value,
    );
    if (registered != null && registered!.participationId != null) {
      // Cache the participation id so the Leave button can call
      // DELETE participations/{id} later in this session.
      emit(state.copyWith(
        participationIdsByEventId: {
          ...state.participationIdsByEventId,
          event.eventId: registered!.participationId!,
        },
      ));
    }
    await _loadCurrent(emit);
    await _loadUpcoming(emit);
    await _loadMy(emit);
  }

  Future<void> _onLoadEventDetail(
    LoadEventDetailEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetail: true, detailError: null));
    final result = await repository.getEventDetail(
      eventId: event.eventId,
      status: event.status,
    );
    result.fold(
      (error) => emit(state.copyWith(
        isLoadingDetail: false,
        detailError: error,
      )),
      (detail) {
        // Cache the participation timestamps (joined_at / finished_at from
        // the completed-event payload) so the Won tab can render real dates.
        final updatedDates = {
          ...state.participationDatesByEventId,
          if (detail.joinedAt != null || detail.finishedAt != null)
            detail.id: (
              joinedAt: detail.joinedAt,
              finishedAt: detail.finishedAt,
            ),
        };
        emit(state.copyWith(
          isLoadingDetail: false,
          eventDetail: detail,
          participationDatesByEventId: updatedDates,
        ));
      },
    );
  }

  Future<void> _onCancelParticipation(
    CancelParticipationEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    final result = await repository.cancelParticipation(
      participationId: event.participationId,
    );
    await result.fold(
      (error) async => emit(state.copyWith(actionError: error)),
      (_) async {
        await _loadCurrent(emit);
        await _loadUpcoming(emit);
        await _loadMy(emit);
      },
    );
  }

  Future<void> _onLoadEventWinners(
    LoadEventWinnersEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    final result = await repository.getWinners(eventId: event.eventId);
    result.fold(
      (error) => emit(state.copyWith(
        actionError: error,
        winnersUnavailableEventIds:
            {...state.winnersUnavailableEventIds, event.eventId},
      )),
      (winners) {
        // The winners endpoint does not exist on the backend yet, so the
        // datasource returns an empty list on failure. Until real data flows,
        // an empty list means "unavailable" rather than "no winners".
        final unavailable = winners.isEmpty;
        emit(state.copyWith(
          winnersByEventId: {...state.winnersByEventId, event.eventId: winners},
          winnersUnavailableEventIds: unavailable
              ? {...state.winnersUnavailableEventIds, event.eventId}
              : {...state.winnersUnavailableEventIds}..remove(event.eventId),
        ));
      },
    );
  }
}