import 'package:equatable/equatable.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/challenge_winner_entity.dart';
import '../../domain/entities/cancelled_event_entity.dart';

class GroupChallengeState extends Equatable {
  final bool isLoadingCurrent;
  final List<GroupChallengeEntity>? currentEvents;
  final String? currentError;

  final bool isLoadingEnded;
  final List<GroupChallengeEntity>? endedEvents;
  final String? endedError;

  final bool isLoadingUpcoming;
  final List<GroupChallengeEntity>? upcomingEvents;
  final String? upcomingError;

  final bool isLoadingMy;
  final List<GroupChallengeEntity>? myEvents;
  final String? myError;

  final bool isLoadingCancelled;
  final List<CancelledEventEntity>? cancelledEvents;
  final String? cancelledError;

  final bool isLoadingDetail;
  final GroupChallengeEntity? eventDetail;
  final String? detailError;

  final Map<int, List<ChallengeWinnerEntity>> winnersByEventId;
  /// eventId -> (joinedAt, finishedAt) captured from completed-event detail
  /// responses, so the Won tab can show real participation/winning dates.
  final Map<int, ({DateTime? joinedAt, DateTime? finishedAt})>
      participationDatesByEventId;
  /// eventId -> participationId, captured from registerForEvent responses.
  /// Needed because GET events/participations does not include the
  /// participation_id; only registrations made this session are known.
  final Map<int, int> participationIdsByEventId;
  /// Events whose winners list could not be fetched (endpoint not available
  /// yet or request failed). The UI shows a neutral placeholder for these.
  final Set<int> winnersUnavailableEventIds;
  final String? actionError; // for register/join failures shown as a snackbar

  const GroupChallengeState({
    this.isLoadingCurrent = false,
    this.currentEvents,
    this.currentError,
    this.isLoadingEnded = false,
    this.endedEvents,
    this.endedError,
    this.isLoadingUpcoming = false,
    this.upcomingEvents,
    this.upcomingError,
    this.isLoadingMy = false,
    this.myEvents,
    this.myError,
    this.isLoadingCancelled = false,
    this.cancelledEvents,
    this.cancelledError,
    this.isLoadingDetail = false,
    this.eventDetail,
    this.detailError,
    this.winnersByEventId = const {},
    this.participationDatesByEventId = const {},
    this.participationIdsByEventId = const {},
    this.winnersUnavailableEventIds = const {},
    this.actionError,
  });

  static const Object _unset = Object();

  GroupChallengeState copyWith({
    bool? isLoadingCurrent,
    List<GroupChallengeEntity>? currentEvents,
    Object? currentError = _unset,
    bool? isLoadingEnded,
    List<GroupChallengeEntity>? endedEvents,
    Object? endedError = _unset,
    bool? isLoadingUpcoming,
    List<GroupChallengeEntity>? upcomingEvents,
    Object? upcomingError = _unset,
    bool? isLoadingMy,
    List<GroupChallengeEntity>? myEvents,
    Object? myError = _unset,
    bool? isLoadingCancelled,
    List<CancelledEventEntity>? cancelledEvents,
    Object? cancelledError = _unset,
    bool? isLoadingDetail,
    Object? eventDetail = _unset,
    Object? detailError = _unset,
    Map<int, List<ChallengeWinnerEntity>>? winnersByEventId,
    Map<int, ({DateTime? joinedAt, DateTime? finishedAt})>?
        participationDatesByEventId,
    Map<int, int>? participationIdsByEventId,
    Set<int>? winnersUnavailableEventIds,
    Object? actionError = _unset,
  }) {
    return GroupChallengeState(
      isLoadingCurrent: isLoadingCurrent ?? this.isLoadingCurrent,
      currentEvents: currentEvents ?? this.currentEvents,
      currentError:
          currentError == _unset ? this.currentError : currentError as String?,
      isLoadingEnded: isLoadingEnded ?? this.isLoadingEnded,
      endedEvents: endedEvents ?? this.endedEvents,
      endedError:
          endedError == _unset ? this.endedError : endedError as String?,
      isLoadingUpcoming: isLoadingUpcoming ?? this.isLoadingUpcoming,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      upcomingError: upcomingError == _unset
          ? this.upcomingError
          : upcomingError as String?,
      isLoadingMy: isLoadingMy ?? this.isLoadingMy,
      myEvents: myEvents ?? this.myEvents,
      myError: myError == _unset ? this.myError : myError as String?,
      isLoadingCancelled: isLoadingCancelled ?? this.isLoadingCancelled,
      cancelledEvents: cancelledEvents ?? this.cancelledEvents,
      cancelledError: cancelledError == _unset
          ? this.cancelledError
          : cancelledError as String?,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      eventDetail:
          eventDetail == _unset ? this.eventDetail : eventDetail as GroupChallengeEntity?,
      detailError:
          detailError == _unset ? this.detailError : detailError as String?,
      winnersByEventId: winnersByEventId ?? this.winnersByEventId,
      participationDatesByEventId:
          participationDatesByEventId ?? this.participationDatesByEventId,
      participationIdsByEventId:
          participationIdsByEventId ?? this.participationIdsByEventId,
      winnersUnavailableEventIds:
          winnersUnavailableEventIds ?? this.winnersUnavailableEventIds,
      actionError: actionError == _unset ? this.actionError : actionError as String?,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingCurrent,
        currentEvents,
        currentError,
        isLoadingEnded,
        endedEvents,
        endedError,
        isLoadingUpcoming,
        upcomingEvents,
        upcomingError,
        isLoadingMy,
        myEvents,
        myError,
        isLoadingCancelled,
        cancelledEvents,
        cancelledError,
        isLoadingDetail,
        eventDetail,
        detailError,
        winnersByEventId,
        participationIdsByEventId,
        participationDatesByEventId,
        winnersUnavailableEventIds,
        actionError,
      ];
}