import '../../domain/entities/individual_challenge_entity.dart';
import 'individual_challenge_question_model.dart';

class IndividualChallengeModel extends IndividualChallengeEntity {
  const IndividualChallengeModel({
    required super.bookId,
    required super.bookTitle,
    required super.questions,
    super.bonusPoints,
  });

  factory IndividualChallengeModel.fromParams({
    required int bookId,
    required String bookTitle,
    required List<IndividualChallengeQuestionModel> questions,
  }) {
    return IndividualChallengeModel(
      bookId: bookId,
      bookTitle: bookTitle,
      questions: questions,
    );
  }
}
