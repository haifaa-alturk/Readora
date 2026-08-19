import '../../domain/entities/individual_challenge_question_entity.dart';

class IndividualChallengeQuestionModel extends IndividualChallengeQuestionEntity {
  const IndividualChallengeQuestionModel({
    required super.id,
    required super.questionText,
    required super.options,
  });

  factory IndividualChallengeQuestionModel.fromJson(Map<String, dynamic> json) {
    return IndividualChallengeQuestionModel(
      id: json['id'] as int,
      questionText: json['question_text'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'options': options,
    };
  }
}