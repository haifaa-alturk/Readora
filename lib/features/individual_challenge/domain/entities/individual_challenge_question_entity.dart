class IndividualChallengeQuestionEntity {
  final int id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  const IndividualChallengeQuestionEntity({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}