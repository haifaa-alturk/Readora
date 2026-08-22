import 'package:dartz/dartz.dart';

import '../entities/group_challenge_entity.dart';
import '../entities/challenge_winner_entity.dart';
import '../entities/cancelled_event_entity.dart';

abstract class GroupChallengeRepositoryInterface {
  Future<Either<String, List<GroupChallengeEntity>>> getCurrentEvents();
  Future<Either<String, List<GroupChallengeEntity>>> getEndedEvents();
  Future<Either<String, List<GroupChallengeEntity>>> getUpcomingEvents();
  Future<Either<String, List<GroupChallengeEntity>>> getMyEvents();
  Future<Either<String, List<CancelledEventEntity>>> getCancelledEvents();
  Future<Either<String, GroupChallengeEntity>> registerForEvent({
    required int eventId,
  });
  Future<Either<String, void>> cancelParticipation({
    required int participationId,
  });
  Future<Either<String, List<ChallengeWinnerEntity>>> getWinners({
    required int eventId,
  });
  Future<Either<String, GroupChallengeEntity>> getEventDetail({
    required int eventId,
    required String status,
  });
}