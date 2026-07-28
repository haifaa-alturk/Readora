class ProfileEntity {
  static const int beginnerThreshold = 0;
  static const int intermediateThreshold = 300;
  static const int advancedThreshold = 1000;

  final int userId;
  final String name;
  final String email;
  final int points;
  final int booksCount;
  final double walletBalance;
  final String? imagePath;

  const ProfileEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.points,
    required this.booksCount,
    required this.walletBalance,
    this.imagePath,
  });

  String get level {
    if (points >= advancedThreshold) return 'Advanced';
    if (points >= intermediateThreshold) return 'Intermediate';
    return 'Beginner';
  }

  static String levelForPoints(int points) {
    if (points >= advancedThreshold) return 'Advanced';
    if (points >= intermediateThreshold) return 'Intermediate';
    return 'Beginner';
  }
}