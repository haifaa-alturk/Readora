class ProfileEntity {
  // ============================================================
  // LEVEL THRESHOLDS
  // ============================================================

  static const int beginnerThreshold = 0;
  static const int intermediateThreshold = 300;
  static const int advancedThreshold = 1000;

  // ============================================================
  // USER DATA
  // ============================================================

  final int userId;
  final String name;
  final String email;

  // النقاط الحقيقية القادمة من الباك
  final int points;

  // عدد الكتب
  final int booksCount;

  // رصيد المحفظة الحقيقي القادم من الباك
  final double walletBalance;

  // صورة المستخدم
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

  // ============================================================
  // USER LEVEL
  // ============================================================

  String get level {
    if (points >= advancedThreshold) {
      return 'Advanced';
    }

    if (points >= intermediateThreshold) {
      return 'Intermediate';
    }

    return 'Beginner';
  }

  // ============================================================
  // LEVEL FROM POINTS
  // ============================================================

  static String levelForPoints(int points) {
    if (points >= advancedThreshold) {
      return 'Advanced';
    }

    if (points >= intermediateThreshold) {
      return 'Intermediate';
    }

    return 'Beginner';
  }
}
