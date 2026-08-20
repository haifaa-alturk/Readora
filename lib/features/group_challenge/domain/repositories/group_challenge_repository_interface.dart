import 'package:dartz/dartz.dart';

import '../entities/group_challenge_entity.dart';
import '../entities/challenge_winner_entity.dart';

abstract class GroupChallengeRepositoryInterface {
  Future<Either<String, List<GroupChallengeEntity>>> getCurrentEvents();
  Future<Either<String, List<GroupChallengeEntity>>> getEndedEvents();
  Future<Either<String, List<GroupChallengeEntity>>> getUpcomingEvents();
  Future<Either<String, List<GroupChallengeEntity>>> getMyEvents();
  Future<Either<String, GroupChallengeEntity>> registerForEvent({
    required int eventId,
  });
  Future<Either<String, List<ChallengeWinnerEntity>>> getWinners({
    required int eventId,
  });
  // Applies a book quiz result (pass or fail) to every CURRENT event the user
  // is registered in that includes this bookId among its requiredBooks.
  // Returns the updated list of current events.
  Future<Either<String, List<GroupChallengeEntity>>> recordBookQuizResult({
    required int bookId,
    required bool passed,
  });
}