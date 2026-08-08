class GroupChallengeEntity {
  final int id;
  final String title;
  final String description;
  final int bonusPoints;
  final int requiredBooks;
  final int requiredQuizzes;
  final DateTime deadline;
  final bool isJoined;
  final int userBooksCompleted;
  final int userQuizzesPassed;
  final String status;

  const GroupChallengeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.bonusPoints,
    required this.requiredBooks,
    required this.requiredQuizzes,
    required this.deadline,
    required this.isJoined,
    required this.userBooksCompleted,
    required this.userQuizzesPassed,
    required this.status,
  });
}
