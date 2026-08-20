class ChallengeWinnerEntity {
  final int userId;
  final String username;
  final String? avatarUrl;
  final int? rank; // 1, 2, 3 or null = unranked winner
  final int pointsAwarded;

  const ChallengeWinnerEntity({
    required this.userId,
    required this.username,
    this.avatarUrl,
    this.rank,
    required this.pointsAwarded,
  });
}