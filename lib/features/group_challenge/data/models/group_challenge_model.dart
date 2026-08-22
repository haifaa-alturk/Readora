import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/required_book_entity.dart';
import '../../domain/entities/book_progress_entity.dart';
import 'required_book_model.dart';

class GroupChallengeModel extends GroupChallengeEntity {
  const GroupChallengeModel({
    required super.id,
    required super.title,
    required super.startDate,
    required super.endDate,
    required super.requiredBooks,
    required super.points,
    required super.status,
    super.isRegistered = false,
    super.userBookProgress = const [],
    super.userOutcome,
    super.userWonDate,
    super.userPointsEarned,
    super.participationId,
    super.joinedAt,
    super.finishedAt,
  });

  /// Parses the raw Laravel Event resource:
  /// { id, event_name, status, start_date, end_date, points, books: [...] }
  /// The user-specific fields (isRegistered, progress, outcome) are NOT part
  /// of this payload; they are set locally after merging participation data.
  /// participationId is likewise never in this payload (known limitation:
  /// GET events/participations does not include it) — it is only populated
  /// from the registerForEvent response.
  factory GroupChallengeModel.fromJson(Map<String, dynamic> json) {
    return GroupChallengeModel(
      id: json['id'] as int? ?? 0,
      title: json['event_name'] as String? ?? '',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : DateTime.now(),
      requiredBooks: (json['books'] as List<dynamic>? ?? [])
          .map((e) => RequiredBookModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      points: json['points'] as int? ?? 0,
      status: json['status'] as String? ?? 'upcoming',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_name': title,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'books': requiredBooks
          .map((e) => (e as RequiredBookModel).toJson())
          .toList(),
      'points': points,
      'status': status,
    };
  }

  static const Object _unset = Object();

  GroupChallengeModel copyWith({
    int? id,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    List<RequiredBookEntity>? requiredBooks,
    int? points,
    String? status,
    bool? isRegistered,
    List<BookProgressEntity>? userBookProgress,
    Object? userOutcome = _unset,
    Object? userWonDate = _unset,
    Object? userPointsEarned = _unset,
    Object? participationId = _unset,
    Object? joinedAt = _unset,
    Object? finishedAt = _unset,
  }) {
    return GroupChallengeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      requiredBooks: requiredBooks ?? this.requiredBooks,
      points: points ?? this.points,
      status: status ?? this.status,
      isRegistered: isRegistered ?? this.isRegistered,
      userBookProgress: userBookProgress ?? this.userBookProgress,
      userOutcome:
          userOutcome == _unset ? this.userOutcome : userOutcome as String?,
      userWonDate:
          userWonDate == _unset ? this.userWonDate : userWonDate as DateTime?,
      userPointsEarned: userPointsEarned == _unset
          ? this.userPointsEarned
          : userPointsEarned as int?,
      participationId: participationId == _unset
          ? this.participationId
          : participationId as int?,
      joinedAt:
          joinedAt == _unset ? this.joinedAt : joinedAt as DateTime?,
      finishedAt:
          finishedAt == _unset ? this.finishedAt : finishedAt as DateTime?,
    );
  }
}