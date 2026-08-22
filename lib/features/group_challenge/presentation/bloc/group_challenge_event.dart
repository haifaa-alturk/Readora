import 'package:equatable/equatable.dart';

abstract class GroupChallengeEvent extends Equatable {
  const GroupChallengeEvent();

  @override
  List<Object?> get props => [];
}

class LoadCurrentEventsEvent extends GroupChallengeEvent {
  const LoadCurrentEventsEvent();
}

class LoadEndedEventsEvent extends GroupChallengeEvent {
  const LoadEndedEventsEvent();
}

class LoadUpcomingEventsEvent extends GroupChallengeEvent {
  const LoadUpcomingEventsEvent();
}

class LoadMyEventsEvent extends GroupChallengeEvent {
  const LoadMyEventsEvent();
}

class LoadCancelledEventsEvent extends GroupChallengeEvent {
  const LoadCancelledEventsEvent();
}

class RegisterForEventEvent extends GroupChallengeEvent {
  final int eventId;

  const RegisterForEventEvent({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class CancelParticipationEvent extends GroupChallengeEvent {
  final int participationId;

  const CancelParticipationEvent({required this.participationId});

  @override
  List<Object?> get props => [participationId];
}

class LoadEventWinnersEvent extends GroupChallengeEvent {
  final int eventId;

  const LoadEventWinnersEvent({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class LoadEventDetailEvent extends GroupChallengeEvent {
  final int eventId;
  final String status;

  const LoadEventDetailEvent({
    required this.eventId,
    required this.status,
  });

  @override
  List<Object?> get props => [eventId, status];
}