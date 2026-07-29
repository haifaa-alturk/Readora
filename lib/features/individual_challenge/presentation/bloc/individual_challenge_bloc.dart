import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/individual_challenge_repository_interface.dart';
import 'individual_challenge_event.dart';
import 'individual_challenge_state.dart';

class IndividualChallengeBloc
    extends Bloc<IndividualChallengeEvent, IndividualChallengeState> {
  final IndividualChallengeRepositoryInterface repository;

  IndividualChallengeBloc({required this.repository})
      : super(const IndividualChallengeInitial()) {
    on<LoadIndividualChallengeEvent>(_onLoadIndividualChallenge);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<SkipChallengeEvent>(_onSkipChallenge);
  }

  Future<void> _onLoadIndividualChallenge(
    LoadIndividualChallengeEvent event,
    Emitter<IndividualChallengeState> emit,
  ) async {
    emit(const IndividualChallengeLoading());

    final result = await repository.getChallenge(
      bookId: event.bookId,
      bookTitle: event.bookTitle,
    );
    result.fold(
      (error) => emit(IndividualChallengeError(message: error)),
      (challenge) {
        emit(IndividualChallengeInProgress(
          challenge: challenge,
          currentQuestionIndex: 0,
          selectedAnswers: List<int?>.filled(challenge.questions.length, null),
        ));
      },
    );
  }

  void _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<IndividualChallengeState> emit,
  ) {
    final state = this.state;
    if (state is! IndividualChallengeInProgress) return;

    final updatedAnswers = List<int?>.from(state.selectedAnswers);
    updatedAnswers[event.questionIndex] = event.selectedOptionIndex;

    final questions = state.challenge.questions;
    if (event.questionIndex == questions.length - 1) {
      final allCorrect = updatedAnswers.asMap().entries.every((entry) {
        final answer = entry.value;
        return answer != null && answer == questions[entry.key].correctOptionIndex;
      });
      if (allCorrect) {
        emit(IndividualChallengePassed(
          bonusPoints: state.challenge.bonusPoints,
        ));
      } else {
        emit(const IndividualChallengeFailed());
      }
    } else {
      emit(IndividualChallengeInProgress(
        challenge: state.challenge,
        currentQuestionIndex: state.currentQuestionIndex,
        selectedAnswers: updatedAnswers,
      ));
    }
  }

  void _onSkipChallenge(
    SkipChallengeEvent event,
    Emitter<IndividualChallengeState> emit,
  ) {
    emit(const IndividualChallengeSkipped());
  }
}
