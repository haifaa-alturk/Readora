import 'individual_challenge_question_entity.dart';

class IndividualChallengeEntity {
  final int bookId;
  final String bookTitle;
  final List<IndividualChallengeQuestionEntity> questions;

  const IndividualChallengeEntity({
    required this.bookId,
    required this.bookTitle,
    required this.questions,
  });
}

class QuizSubmissionResult {
  final bool passed;
  final int correctAnswers;
  final int pointsEarned;
  final int currentTotalPoints;
  final String message;

  const QuizSubmissionResult({
    required this.passed,
    required this.correctAnswers,
    required this.pointsEarned,
    required this.currentTotalPoints,
    required this.message,
  });
}