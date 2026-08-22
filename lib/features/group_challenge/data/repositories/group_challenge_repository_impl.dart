import 'package:dartz/dartz.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/challenge_winner_entity.dart';
import '../../domain/entities/cancelled_event_entity.dart';
import '../../domain/repositories/group_challenge_repository_interface.dart';
import '../datasources/group_challenge_remote_datasource.dart';
import '../models/group_challenge_model.dart';

class GroupChallengeRepositoryImpl
    implements GroupChallengeRepositoryInterface {
  final GroupChallengeRemoteDataSource _remoteDataSource;

  GroupChallengeRepositoryImpl(this._remoteDataSource);

  /// Fetches the user's participation-derived lists (joined events, wins,
  /// losses) once, in parallel, so they can be reused across the whole base
  /// event list instead of being refetched per event.
  Future<(Set<int>, Set<int>, Set<int>)> _fetchUserEventSets() async {
    final results = await Future.wait([
      _remoteDataSource.getMyEvents(),
      _remoteDataSource.getWinEvents(),
      _remoteDataSource.getLoseEvents(),
    ]);
    final participatedIds =
        results[0].map((e) => e.id).toSet();
    final wonIds = results[1].map((e) => e.id).toSet();
    final lostIds = results[2].map((e) => e.id).toSet();
    return (participatedIds, wonIds, lostIds);
  }

  /// Merges backend participation data into a base event list:
  /// - isRegistered: the event appears in the user's participations.
  /// - userOutcome: 'won' / 'lost' from the win/lose lists, otherwise
  ///   'ongoing' or 'registered' depending on status for joined events.
  /// - userBookProgress: TODO: Backend does not expose per-book progress
  ///   within an event yet; requires a new endpoint, e.g.
  ///   GET /events/{id}/my-progress, to properly populate this.
  List<GroupChallengeEntity> _mergeWithUserData(
    List<GroupChallengeEntity> events,
    Set<int> participatedIds,
    Set<int> wonIds,
    Set<int> lostIds,
  ) {
    return events.map((event) {
      final isRegistered = participatedIds.contains(event.id);
      String? userOutcome;
      if (wonIds.contains(event.id)) {
        userOutcome = 'won';
      } else if (lostIds.contains(event.id)) {
        userOutcome = 'lost';
      } else if (isRegistered && event.status == 'ongoing') {
        userOutcome = 'ongoing';
      } else if (isRegistered && event.status == 'upcoming') {
        userOutcome = 'registered';
      }

      return GroupChallengeModel(
        id: event.id,
        title: event.title,
        startDate: event.startDate,
        endDate: event.endDate,
        requiredBooks: event.requiredBooks,
        points: event.points,
        status: event.status,
        isRegistered: isRegistered,
        // TODO: backend does not expose per-book progress yet
        // (needs GET /events/{id}/my-progress)
        userBookProgress: const [],
        userOutcome: userOutcome,
        userPointsEarned: userOutcome == 'won' ? event.points : null,
        // Preserve a participationId captured at registration time, if any.
        // KNOWN LIMITATION: GET events/participations does not return the
        // participation_id, so events fetched from list endpoints have null
        // here unless they were registered during this app session (the bloc
        // caches the id from the register response in
        // participationIdsByEventId). Backend should include participation_id
        // in the participations response to fix this properly.
        participationId: event.participationId,
      );
    }).toList();
  }

  Future<Either<String, List<GroupChallengeEntity>>> _getEventsMerged(
    Future<List<GroupChallengeEntity>> Function() fetchBase,
  ) async {
    try {
      final baseEvents = await fetchBase();
      final (participatedIds, wonIds, lostIds) =
          await _fetchUserEventSets();
      return Right(_mergeWithUserData(
        baseEvents,
        participatedIds,
        wonIds,
        lostIds,
      ));
    } catch (e) {
      return Left('Error fetching events: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<GroupChallengeEntity>>> getCurrentEvents() {
    return _getEventsMerged(_remoteDataSource.getCurrentEvents);
  }

  @override
  Future<Either<String, List<GroupChallengeEntity>>> getEndedEvents() {
    return _getEventsMerged(_remoteDataSource.getEndedEvents);
  }

  @override
  Future<Either<String, List<GroupChallengeEntity>>> getUpcomingEvents() {
    return _getEventsMerged(_remoteDataSource.getUpcomingEvents);
  }

  @override
  Future<Either<String, List<GroupChallengeEntity>>> getMyEvents() {
    return _getEventsMerged(_remoteDataSource.getMyEvents);
  }

  @override
  Future<Either<String, List<CancelledEventEntity>>> getCancelledEvents() async {
    try {
      final result = await _remoteDataSource.getCancelledEvents();
      return Right(result);
    } catch (e) {
      return Left('Error fetching cancelled events: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GroupChallengeEntity>> registerForEvent({
    required int eventId,
  }) async {
    try {
      final result = await _remoteDataSource.registerForEvent(eventId: eventId);
      return Right(result);
    } on AlreadyRegisteredException {
      return Left('You have already joined this event.');
    } catch (e) {
      return Left('Error registering for event: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, GroupChallengeEntity>> getEventDetail({
    required int eventId,
    required String status,
  }) async {
    try {
      final result = await _remoteDataSource.getEventDetail(
        eventId: eventId,
        status: status,
      );
      return Right(result);
    } catch (e) {
      return Left('Error fetching event detail: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> cancelParticipation({
    required int participationId,
  }) async {
    try {
      await _remoteDataSource.cancelParticipation(
        participationId: participationId,
      );
      return Right(null);
    } catch (e) {
      return Left('Error cancelling participation: ${e.toString()}');
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
}
