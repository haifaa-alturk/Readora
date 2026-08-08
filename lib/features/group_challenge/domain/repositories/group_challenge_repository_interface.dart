import 'package:dartz/dartz.dart';

import '../entities/group_challenge_entity.dart';
import '../entities/challenge_winner_entity.dart';

abstract class GroupChallengeRepositoryInterface {
  Future<Either<String, GroupChallengeEntity?>> getActiveChallenge();
  Future<Either<String, GroupChallengeEntity>> joinChallenge({
    required int challengeId,
  });
  Future<Either<String, List<ChallengeWinnerEntity>>> getWinners({
    required int challengeId,
  });
  Future<Either<String, GroupChallengeEntity>> incrementBookProgress({required int challengeId});
}
