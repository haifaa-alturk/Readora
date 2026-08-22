import '../../domain/entities/challenge_winner_entity.dart';

class ChallengeWinnerModel extends ChallengeWinnerEntity {
  const ChallengeWinnerModel({
    required super.username,
    required super.pointsAwarded,
  });

  factory ChallengeWinnerModel.fromJson(Map<String, dynamic> json) {
    return ChallengeWinnerModel(
      username: json['name'] as String? ?? '',
      pointsAwarded: json['points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'points_awarded': pointsAwarded,
    };
  }
}
