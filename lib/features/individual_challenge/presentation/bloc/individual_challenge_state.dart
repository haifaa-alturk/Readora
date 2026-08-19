import 'package:equatable/equatable.dart';

import '../../domain/entities/individual_challenge_entity.dart';

abstract class IndividualChallengeState extends Equatable {
  const IndividualChallengeState();

  @override
  List<Object?> get props => [];
}

class IndividualChallengeInitial extends IndividualChallengeState {
  const IndividualChallengeInitial();
}

class IndividualChallengeLoading extends IndividualChallengeState {
  const IndividualChallengeLoading();
}

class IndividualChallengeInProgress extends IndividualChallengeState {
  final IndividualChallengeEntity challenge;
  final int currentQuestionIndex;
  final List<String?> selectedAnswers;

  const IndividualChallengeInProgress({
    required this.challenge,
    required this.currentQuestionIndex,
    required this.selectedAnswers,
  });

  @override
  List<Object?> get props => [challenge, currentQuestionIndex, selectedAnswers];
}

class IndividualChallengePassed extends IndividualChallengeState {
  final int bonusPoints;

  const IndividualChallengePassed({required this.bonusPoints});

  @override
  List<Object?> get props => [bonusPoints];
}

class IndividualChallengeFailed extends IndividualChallengeState {
  const IndividualChallengeFailed();
}

class IndividualChallengeSkipped extends IndividualChallengeState {
  const IndividualChallengeSkipped();
}

class IndividualChallengeError extends IndividualChallengeState {
  final String message;

  const IndividualChallengeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class IndividualChallengeAlreadyAttempted extends IndividualChallengeState {
  const IndividualChallengeAlreadyAttempted();
}

class IndividualChallengeQuizUnavailable extends IndividualChallengeState {
  const IndividualChallengeQuizUnavailable();
}