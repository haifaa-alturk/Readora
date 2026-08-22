import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../models/group_challenge_model.dart';
import '../models/cancelled_event_model.dart';
import '../models/challenge_winner_model.dart';
import '../models/book_progress_model.dart';

/// Thrown when registering for an event the user has already joined
/// (backend responds with 409).
class AlreadyRegisteredException implements Exception {
  const AlreadyRegisteredException();
}

abstract class GroupChallengeRemoteDataSource {
  Future<List<GroupChallengeModel>> getCurrentEvents();
  Future<List<GroupChallengeModel>> getEndedEvents();
  Future<List<GroupChallengeModel>> getUpcomingEvents();
  Future<List<GroupChallengeModel>> getMyEvents();
  Future<List<GroupChallengeModel>> getWinEvents();
  Future<List<GroupChallengeModel>> getLoseEvents();
  Future<List<CancelledEventModel>> getCancelledEvents();
  Future<List<ChallengeWinnerModel>> getWinners({required int eventId});
  Future<GroupChallengeModel> getEventDetail({
    required int eventId,
    required String status,
  });
  Future<GroupChallengeModel> registerForEvent({required int eventId});
  Future<void> cancelParticipation({required int participationId});
}

class GroupChallengeRemoteDataSourceImpl
    implements GroupChallengeRemoteDataSource {
  GroupChallengeRemoteDataSourceImpl(this._realApiClient);

  final ApiClient _realApiClient;

  List<GroupChallengeModel> _parseEventList(dynamic data) {
    final list = data as List<dynamic>? ?? const [];
    return list
        .map(
          (e) => GroupChallengeModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  @override
  Future<List<GroupChallengeModel>> getCurrentEvents() async {
    final response = await _realApiClient.dio.get('events/ongoing');
    return _parseEventList(response.data);
  }

  @override
  Future<List<GroupChallengeModel>> getEndedEvents() async {
    final response = await _realApiClient.dio.get('events/completed');
    return _parseEventList(response.data);
  }

  @override
  Future<List<GroupChallengeModel>> getUpcomingEvents() async {
    final response = await _realApiClient.dio.get('events/upcoming');
    return _parseEventList(response.data);
  }

  @override
  Future<List<GroupChallengeModel>> getMyEvents() async {
    final response = await _realApiClient.dio.get('events/participations');
    return _parseEventList(response.data);
  }

  @override
  Future<List<GroupChallengeModel>> getWinEvents() async {
    final response = await _realApiClient.dio.get('events/wins');
    return _parseEventList(response.data);
  }

  @override
  Future<List<GroupChallengeModel>> getLoseEvents() async {
    final response = await _realApiClient.dio.get('events/losses');
    return _parseEventList(response.data);
  }

  @override
  Future<List<CancelledEventModel>> getCancelledEvents() async {
    final response = await _realApiClient.dio.get('events/cancelled');
    final list = response.data as List<dynamic>? ?? const [];
    return list
        .map(
          (e) => CancelledEventModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  /// Forward-compatible winners fetch: GET events/completed/$eventId returns
  /// the completed event with a "winners" key. Any failure (404 via
  /// firstOrFail when the event isn't completed yet, route missing, server
  /// error, etc.) yields an empty list instead of throwing; the bloc flags
  /// the event as "winners unavailable" so the UI can show a placeholder.
  @override
  Future<List<ChallengeWinnerModel>> getWinners({required int eventId}) async {
    try {
      final response =
          await _realApiClient.dio.get('events/completed/$eventId');
      final json = Map<String, dynamic>.from(response.data as Map);
      final winners = json['winners'] as List<dynamic>? ?? const [];
      return winners
          .map(
            (e) => ChallengeWinnerModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// Fetches a single event's full detail for the given status segment
  /// ('ongoing', 'completed', 'upcoming' or 'cancelled').
  ///
  /// - ongoing/completed: { "event": {...}, "books": [ ...with status... ],
  ///   "winners": [...] (completed only) } — the event is parsed via
  ///   GroupChallengeModel.fromJson and "books" is attached as
  ///   userBookProgress.
  /// - upcoming/cancelled: the flat event object directly, parsed with an
  ///   empty userBookProgress.
  @override
  Future<GroupChallengeModel> getEventDetail({
    required int eventId,
    required String status,
  }) async {
    final response = await _realApiClient.dio.get('events/$status/$eventId');
    final json = Map<String, dynamic>.from(response.data as Map);

    if (status == 'ongoing' || status == 'completed') {
      final event = GroupChallengeModel.fromJson(
        Map<String, dynamic>.from(json['event'] as Map),
      );
      final books = json['books'] as List<dynamic>? ?? const [];
      final progress = books
          .map(
            (e) => BookProgressModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
      // The completed payload also carries the current user's participation
      // timestamps at the top level: joined_at / finished_at.
      DateTime? parseDate(dynamic raw) =>
          raw is String && raw.isNotEmpty ? DateTime.tryParse(raw) : null;
      return event.copyWith(
        userBookProgress: progress,
        joinedAt: parseDate(json['joined_at']),
        finishedAt: parseDate(json['finished_at']),
      );
    }

    return GroupChallengeModel.fromJson(json);
  }

  @override
  Future<GroupChallengeModel> registerForEvent({required int eventId}) async {
    try {
      final response = await _realApiClient.dio.post('participations/$eventId');
      // The backend wraps the created Participation object (NOT the event):
      // {"message": ..., "data": {id, user_id, event_id, status, joined_at}}
      final json = Map<String, dynamic>.from(response.data as Map);
      final participation = Map<String, dynamic>.from(json['data'] as Map);
      // Return a minimal model carrying the event id and, crucially, the
      // participation id needed later for DELETE participations/{id}.
      return GroupChallengeModel(
        id: participation['event_id'] as int? ?? eventId,
        title: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        requiredBooks: const [],
        points: 0,
        status: 'upcoming',
        isRegistered: true,
        participationId: participation['id'] as int?,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw const AlreadyRegisteredException();
      }
      rethrow;
    }
  }

  @override
  Future<void> cancelParticipation({required int participationId}) async {
    await _realApiClient.dio.delete('participations/$participationId');
  }
}
