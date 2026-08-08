import '../../domain/entities/win_entity.dart';

class WinModel extends WinEntity {
  const WinModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconName,
    super.dateEarned,
    required super.type,
    super.rank,
    super.eventName,
    super.challengeId,
    super.challengeType,
    super.reward,
    super.earnedPoints,
    super.completedDate,
    super.certificateImage,
    super.status,
  });

  factory WinModel.fromJson(Map<String, dynamic> json) {
    return WinModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['icon_name'] as String? ?? 'emoji_events',
      dateEarned: json['date_earned'] != null
          ? DateTime.parse(json['date_earned'] as String)
          : null,
      type: json['type'] as String? ?? 'achievement',
      rank: json['rank'] as int?,
      eventName: json['event_name'] as String?,
      challengeId: json['challenge_id'] as int?,
      challengeType: json['challenge_type'] as String?,
      reward: json['reward'] as String?,
      earnedPoints: json['earned_points'] as int?,
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'] as String)
          : null,
      certificateImage: json['certificate_image'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_name': iconName,
      'date_earned': dateEarned?.toIso8601String(),
      'type': type,
      'rank': rank,
      'event_name': eventName,
      'challenge_id': challengeId,
      'challenge_type': challengeType,
      'reward': reward,
      'earned_points': earnedPoints,
      'completed_date': completedDate?.toIso8601String(),
      'certificate_image': certificateImage,
      'status': status,
    };
  }
}