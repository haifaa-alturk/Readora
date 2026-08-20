import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/group_challenge_model.dart';
import '../models/challenge_winner_model.dart';
import '../models/book_progress_model.dart';

abstract class GroupChallengeRemoteDataSource {
  Future<List<GroupChallengeModel>> getCurrentEvents();
  Future<List<GroupChallengeModel>> getEndedEvents();
  Future<List<GroupChallengeModel>> getUpcomingEvents();
  Future<List<GroupChallengeModel>> getMyEvents();
  Future<GroupChallengeModel> registerForEvent({required int eventId});
  Future<List<ChallengeWinnerModel>> getWinners({required int eventId});
  Future<List<GroupChallengeModel>> recordBookQuizResult({
    required int bookId,
    required bool passed,
  });
}

class GroupChallengeRemoteDataSourceImpl
    implements GroupChallengeRemoteDataSource {
  GroupChallengeRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;

  List<GroupChallengeModel>? _allEvents;

  Future<void> _ensureLoaded() async {
    if (_allEvents != null) return;

    final events = <Map<String, dynamic>>[];
    if (useMockData) {
      events
        ..addAll(MockDataProvider.groupEventsCurrent())
        ..addAll(MockDataProvider.groupEventsEnded())
        ..addAll(MockDataProvider.groupEventsUpcoming());
    } else {
      // TODO: confirm real group-events endpoints with backend team.
      // final current = await _apiClient.get('/group-events?status=current');
      // final ended = await _apiClient.get('/group-events?status=ended');
      // final upcoming = await _apiClient.get('/group-events?status=upcoming');
      // ... would map each list here ...
      events
        ..addAll(MockDataProvider.groupEventsCurrent())
        ..addAll(MockDataProvider.groupEventsEnded())
        ..addAll(MockDataProvider.groupEventsUpcoming());
    }

    _allEvents = events.map((e) => GroupChallengeModel.fromJson(e)).toList();
  }

  @override
  Future<List<GroupChallengeModel>> getCurrentEvents() async {
    await _ensureLoaded();
    return _allEvents!.where((e) => e.status == 'current').toList();
  }

  @override
  Future<List<GroupChallengeModel>> getEndedEvents() async {
    await _ensureLoaded();
    return _allEvents!.where((e) => e.status == 'ended').toList();
  }

  @override
  Future<List<GroupChallengeModel>> getUpcomingEvents() async {
    await _ensureLoaded();
    return _allEvents!.where((e) => e.status == 'upcoming').toList();
  }

  @override
  Future<List<GroupChallengeModel>> getMyEvents() async {
    await _ensureLoaded();
    return _allEvents!.where((e) => e.isRegistered).toList();
  }

  @override
  Future<GroupChallengeModel> registerForEvent({
    required int eventId,
  }) async {
    await _ensureLoaded();
    final index = _allEvents!.indexWhere((e) => e.id == eventId);
    if (index == -1) {
      throw Exception('Event not found');
    }

    final event = _allEvents![index];
    late GroupChallengeModel updated;
    if (event.status == 'current') {
      updated = event.copyWith(
        isRegistered: true,
        userOutcome: 'ongoing',
        userBookProgress: event.requiredBooks
            .map(
              (rb) => BookProgressModel(
                bookId: rb.bookId,
                title: rb.title,
                isCompleted: false,
                isFailed: false,
              ),
            )
            .toList(),
      );
    } else {
      updated = event.copyWith(
        isRegistered: true,
        userOutcome: 'registered',
      );
    }

    _allEvents![index] = updated;
    return updated;
  }

  @override
  Future<List<ChallengeWinnerModel>> getWinners({
    required int eventId,
  }) async {
    if (useMockData) {
      final data = MockDataProvider.groupEventWinners(eventId);
      return data.map((e) => ChallengeWinnerModel.fromJson(e)).toList();
    }
    // TODO: confirm real group-events winners endpoint with backend team.
    // final response = await _apiClient.get('/group-events/$eventId/winners');
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((e) => ChallengeWinnerModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
    final data = MockDataProvider.groupEventWinners(eventId);
    return data.map((e) => ChallengeWinnerModel.fromJson(e)).toList();
  }

  // NOTE: both 'won' and 'lost' are decided in real time here, not deferred to
  // event end. 'lost' is absolute and overrides prior progress. 'won' fires the
  // instant the last required book is completed; its rank/points use
  // MockDataProvider.groupEventOtherFinishersCount() as a temporary local
  // simulation of the other participants, since only the real backend can know
  // the true finishing order once it exists.
  @override
  Future<List<GroupChallengeModel>> recordBookQuizResult({
    required int bookId,
    required bool passed,
  }) async {
    await _ensureLoaded();

    final updated = _allEvents!.map((event) {
      final isCandidate = event.status == 'current' &&
          event.isRegistered &&
          event.userOutcome != 'lost' &&
          event.userOutcome != 'won' &&
          event.requiredBooks.any((rb) => rb.bookId == bookId);
      return isCandidate ? _applyQuizResult(event, bookId, passed) : event;
    }).toList();

    _allEvents = updated;
    return getCurrentEvents();
  }

  GroupChallengeModel _applyQuizResult(
    GroupChallengeModel event,
    int bookId,
    bool passed,
  ) {
    final progress = event.userBookProgress
        .map((p) => p.bookId == bookId
            ? BookProgressModel(
                bookId: p.bookId,
                title: p.title,
                isCompleted: passed,
                isFailed: !passed,
              )
            : p)
        .toList();

    if (!passed) {
      return event.copyWith(
        userBookProgress: progress,
        userOutcome: 'lost',
        userWonDate: null,
        userPointsEarned: null,
      );
    }

    final allComplete = progress.every((p) => p.isCompleted);
    if (allComplete) {
      final otherFinishers = MockDataProvider.groupEventOtherFinishersCount(event.id);
      final rank = otherFinishers + 1;
      final points = rank == 1
          ? event.firstPlacePoints
          : rank == 2
              ? event.secondPlacePoints
              : rank == 3
                  ? event.thirdPlacePoints
                  : event.participantPoints;
      return event.copyWith(
        userBookProgress: progress,
        userOutcome: 'won',
        userWonDate: DateTime.now(),
        userPointsEarned: points,
      );
    }

    return event.copyWith(
      userBookProgress: progress,
      userOutcome: 'ongoing',
    );
  }
}