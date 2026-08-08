import 'package:dartz/dartz.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/challenge_winner_entity.dart';
import '../../domain/repositories/group_challenge_repository_interface.dart';
import '../datasources/group_challenge_remote_datasource.dart';

class GroupChallengeRepositoryImpl
    implements GroupChallengeRepositoryInterface {
  final GroupChallengeRemoteDataSource _remoteDataSource;

  GroupChallengeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, GroupChallengeEntity?>> getActiveChallenge() async {
    try {
      final result = await _remoteDataSource.getActiveChallenge();
      return Right(result);
    } catch (e) {
      return Left('Error fetching active challenge: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GroupChallengeEntity>> joinChallenge({
    required int challengeId,
  }) async {
    try {
      final result = await _remoteDataSource.joinChallenge(
        challengeId: challengeId,
      );
      return Right(result);
    } catch (e) {
      return Left('Error joining challenge: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ChallengeWinnerEntity>>> getWinners({
    required int challengeId,
  }) async {
    try {
      final result =
          await _remoteDataSource.getWinners(challengeId: challengeId);
      return Right(result);
    } catch (e) {
      return Left('Error fetching winners: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GroupChallengeEntity>> incrementBookProgress({
    required int challengeId,
  }) async {
    try {
      final result = await _remoteDataSource.incrementBookProgress(
        challengeId: challengeId,
      );
      return Right(result);
    } catch (e) {
      return Left('Error updating challenge progress: ${e.toString()}');
    }
  }
}
