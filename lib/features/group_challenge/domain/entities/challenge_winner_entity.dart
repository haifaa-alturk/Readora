class ChallengeWinnerEntity {
  final int userId;
  final String username;
  final String? avatarUrl;

  const ChallengeWinnerEntity({
    required this.userId,
    required this.username,
    this.avatarUrl,
  });
}
