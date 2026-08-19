import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/individual_challenge_remote_datasource.dart';
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

    try {
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
            selectedAnswers: List<String?>.filled(challenge.questions.length, null),
          ));
        },
      );
    } on QuizAlreadyAttemptedException {
      emit(const IndividualChallengeAlreadyAttempted());
    } on QuizUnavailableException {
      emit(const IndividualChallengeQuizUnavailable());
    } catch (e) {
      emit(IndividualChallengeError(message: e.toString()));
    }
  }

  Future<void> _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<IndividualChallengeState> emit,
  ) async {
    final state = this.state;
    if (state is! IndividualChallengeInProgress) return;

    final updatedAnswers = List<String?>.from(state.selectedAnswers);
    updatedAnswers[event.questionIndex] = event.selectedOptionText;

    final questions = state.challenge.questions;
    if (event.questionIndex == questions.length - 1) {
      final answersPayload = <Map<String, dynamic>>[];
      for (var i = 0; i < questions.length; i++) {
        final text = updatedAnswers[i];
        if (text != null) {
          answersPayload.add({
            'question_id': questions[i].id,
            'user_answer': text,
          });
        }
      }

      emit(IndividualChallengeInProgress(
        challenge: state.challenge,
        currentQuestionIndex: state.currentQuestionIndex,
        selectedAnswers: updatedAnswers,
      ));

      try {
        final result = await repository.submitQuiz(
          bookId: state.challenge.bookId,
          answers: answersPayload,
        );
        result.fold(
          (error) => emit(IndividualChallengeError(message: error)),
          (submission) {
            if (submission.passed) {
              emit(IndividualChallengePassed(
                bonusPoints: submission.pointsEarned,
              ));
            } else {
              emit(const IndividualChallengeFailed());
            }
          },
        );
      } on QuizAlreadyAttemptedException {
        emit(const IndividualChallengeAlreadyAttempted());
      } on QuizUnavailableException {
        emit(const IndividualChallengeQuizUnavailable());
      } catch (e) {
        emit(IndividualChallengeError(message: e.toString()));
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