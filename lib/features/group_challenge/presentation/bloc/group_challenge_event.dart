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

class RegisterForEventEvent extends GroupChallengeEvent {
  final int eventId;

  const RegisterForEventEvent({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class LoadEventWinnersEvent extends GroupChallengeEvent {
  final int eventId;

  const LoadEventWinnersEvent({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class RecordBookQuizResultEvent extends GroupChallengeEvent {
  final int bookId;
  final bool passed;

  const RecordBookQuizResultEvent({
    required this.bookId,
    required this.passed,
  });

  @override
  List<Object?> get props => [bookId, passed];
}