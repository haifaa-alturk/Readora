class WinEntity {
  final int id;
  final String title;
  final String description;
  final String iconName;
  final DateTime? dateEarned;
  final String type;
  final int? rank;
  final String? eventName;
  final int? challengeId;
  final String? challengeType;
  final String? reward;
  final int? earnedPoints;
  final DateTime? completedDate;
  final String? certificateImage;
  final String? status;

  const WinEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.dateEarned,
    required this.type,
    this.rank,
    this.eventName,
    this.challengeId,
    this.challengeType,
    this.reward,
    this.earnedPoints,
    this.completedDate,
    this.certificateImage,
    this.status,
  });

  bool get isRanked => rank != null && eventName != null;

  bool get isChallengeWin => challengeType != null;

  String get rankLabel {
    switch (rank) {
      case 1:
        return '1st Place';
      case 2:
        return '2nd Place';
      case 3:
        return '3rd Place';
      default:
        return '';
    }
  }
}