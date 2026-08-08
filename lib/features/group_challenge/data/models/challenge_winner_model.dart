import '../../domain/entities/challenge_winner_entity.dart';

class ChallengeWinnerModel extends ChallengeWinnerEntity {
  const ChallengeWinnerModel({
    required super.userId,
    required super.username,
    super.avatarUrl,
  });

  factory ChallengeWinnerModel.fromJson(Map<String, dynamic> json) {
    return ChallengeWinnerModel(
      userId: json['user_id'] as int,
      username: json['username'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'avatar_url': avatarUrl,
    };
  }
}
