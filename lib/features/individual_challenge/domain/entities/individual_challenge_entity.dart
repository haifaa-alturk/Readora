import 'individual_challenge_question_entity.dart';

class IndividualChallengeEntity {
  final int bookId;
  final String bookTitle;
  final List<IndividualChallengeQuestionEntity> questions;
  final int bonusPoints;

  const IndividualChallengeEntity({
    required this.bookId,
    required this.bookTitle,
    required this.questions,
    this.bonusPoints = 3,
  });
}