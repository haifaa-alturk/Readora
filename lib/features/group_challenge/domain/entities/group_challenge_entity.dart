import 'required_book_entity.dart';
import 'book_progress_entity.dart';

class GroupChallengeEntity {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<RequiredBookEntity> requiredBooks;
  final int points;
  final String status; // 'upcoming' | 'ongoing' | 'completed' | 'cancelled' (Laravel enum)
  final bool isRegistered;
  final List<BookProgressEntity> userBookProgress;
  final String? userOutcome; // null | 'registered' | 'ongoing' | 'won' | 'lost'
  final DateTime? userWonDate;
  final int? userPointsEarned;
  /// Id of the current user's Participation row for this event.
  /// NOT part of the event JSON — only known right after the user registers
  /// (POST participations returns the participation object). Null for events
  /// loaded from list endpoints; see repository/bloc for the session cache.
  final int? participationId;
  /// When the current user joined this event (participations.joined_at).
  /// Only present on detail responses for completed/ongoing events.
  final DateTime? joinedAt;
  /// When the current user finished/won this event
  /// (participations.finished_at). Only present on completed detail responses.
  final DateTime? finishedAt;

  const GroupChallengeEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.requiredBooks,
    required this.points,
    required this.status,
    required this.isRegistered,
    required this.userBookProgress,
    this.userOutcome,
    this.userWonDate,
    this.userPointsEarned,
    this.participationId,
    this.joinedAt,
    this.finishedAt,
  });
}