import 'package:equatable/equatable.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/challenge_winner_entity.dart';

abstract class GroupChallengeState extends Equatable {
  const GroupChallengeState();

  @override
  List<Object?> get props => [];
}

class GroupChallengeInitial extends GroupChallengeState {
  const GroupChallengeInitial();
}

class GroupChallengeLoading extends GroupChallengeState {
  const GroupChallengeLoading();
}

class GroupChallengeActive extends GroupChallengeState {
  final GroupChallengeEntity challenge;

  const GroupChallengeActive({required this.challenge});

  @override
  List<Object?> get props => [challenge];
}

class GroupChallengeWinnersAvailable extends GroupChallengeState {
  final List<ChallengeWinnerEntity> winners;
  final GroupChallengeEntity endedChallenge;

  const GroupChallengeWinnersAvailable({
    required this.winners,
    required this.endedChallenge,
  });

  @override
  List<Object?> get props => [winners, endedChallenge];
}

class GroupChallengeEmpty extends GroupChallengeState {
  const GroupChallengeEmpty();
}

class GroupChallengeError extends GroupChallengeState {
  final String message;

  const GroupChallengeError({required this.message});

  @override
  List<Object?> get props => [message];
}
