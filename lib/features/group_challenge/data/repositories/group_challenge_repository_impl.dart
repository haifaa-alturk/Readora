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
  Future<Either<String, List<GroupChallengeEntity>>> getCurrentEvents() async {
    try {
      final result = await _remoteDataSource.getCurrentEvents();
      return Right(result);
    } catch (e) {
      return Left('Error fetching current events: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<GroupChallengeEntity>>> getEndedEvents() async {
    try {
      final result = await _remoteDataSource.getEndedEvents();
      return Right(result);
    } catch (e) {
      return Left('Error fetching ended events: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<GroupChallengeEntity>>> getUpcomingEvents() async {
    try {
      final result = await _remoteDataSource.getUpcomingEvents();
      return Right(result);
    } catch (e) {
      return Left('Error fetching upcoming events: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<GroupChallengeEntity>>> getMyEvents() async {
    try {
      final result = await _remoteDataSource.getMyEvents();
      return Right(result);
    } catch (e) {
      return Left('Error fetching my events: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GroupChallengeEntity>> registerForEvent({
    required int eventId,
  }) async {
    try {
      final result = await _remoteDataSource.registerForEvent(eventId: eventId);
      return Right(result);
    } catch (e) {
      return Left('Error registering for event: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ChallengeWinnerEntity>>> getWinners({
    required int eventId,
  }) async {
    try {
      final result = await _remoteDataSource.getWinners(eventId: eventId);
      return Right(result);
    } catch (e) {
      return Left('Error fetching event winners: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<GroupChallengeEntity>>> recordBookQuizResult({
    required int bookId,
    required bool passed,
  }) async {
    try {
      final result = await _remoteDataSource.recordBookQuizResult(
        bookId: bookId,
        passed: passed,
      );
      return Right(result);
    } catch (e) {
      return Left('Error recording book quiz result: ${e.toString()}');
    }
  }
}