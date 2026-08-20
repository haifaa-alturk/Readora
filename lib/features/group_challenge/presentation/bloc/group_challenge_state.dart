import 'package:equatable/equatable.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/challenge_winner_entity.dart';

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

  final Map<int, List<ChallengeWinnerEntity>> winnersByEventId;
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
    this.winnersByEventId = const {},
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
    Map<int, List<ChallengeWinnerEntity>>? winnersByEventId,
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
      winnersByEventId: winnersByEventId ?? this.winnersByEventId,
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
        winnersByEventId,
        actionError,
      ];
}