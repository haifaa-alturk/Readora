class IndividualChallengeQuestionEntity {
  final int id;
  final String questionText;
  final List<String> options;

  const IndividualChallengeQuestionEntity({
    required this.id,
    required this.questionText,
    required this.options,
  });
}