import 'package:equatable/equatable.dart';

abstract class GroupChallengeEvent extends Equatable {
  const GroupChallengeEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroupChallengeEvent extends GroupChallengeEvent {
  const LoadGroupChallengeEvent();
}

class JoinChallengeEvent extends GroupChallengeEvent {
  final int challengeId;

  const JoinChallengeEvent({required this.challengeId});

  @override
  List<Object?> get props => [challengeId];
}

class DismissChallengeEvent extends GroupChallengeEvent {
  const DismissChallengeEvent();
}

class RefreshGroupChallengeEvent extends GroupChallengeEvent {
  const RefreshGroupChallengeEvent();
}

class RecordBookCompletionEvent extends GroupChallengeEvent {
  const RecordBookCompletionEvent();
}
