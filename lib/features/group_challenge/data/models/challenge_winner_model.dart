import '../../domain/entities/challenge_winner_entity.dart';

class ChallengeWinnerModel extends ChallengeWinnerEntity {
  const ChallengeWinnerModel({
    required super.userId,
    required super.username,
    super.avatarUrl,
    super.rank,
    required super.pointsAwarded,
  });

  factory ChallengeWinnerModel.fromJson(Map<String, dynamic> json) {
    return ChallengeWinnerModel(
      userId: json['user_id'] as int,
      username: json['username'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      rank: json['rank'] as int?,
      pointsAwarded: json['points_awarded'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'avatar_url': avatarUrl,
      'rank': rank,
      'points_awarded': pointsAwarded,
    };
  }
}