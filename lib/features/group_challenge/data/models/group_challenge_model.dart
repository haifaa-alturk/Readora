import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/required_book_entity.dart';
import '../../domain/entities/book_progress_entity.dart';
import 'required_book_model.dart';
import 'book_progress_model.dart';

class GroupChallengeModel extends GroupChallengeEntity {
  const GroupChallengeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.requiredBooks,
    required super.firstPlacePoints,
    required super.secondPlacePoints,
    required super.thirdPlacePoints,
    required super.participantPoints,
    required super.status,
    required super.isRegistered,
    required super.userBookProgress,
    super.userOutcome,
    super.userWonDate,
    super.userPointsEarned,
  });

  factory GroupChallengeModel.fromJson(Map<String, dynamic> json) {
    return GroupChallengeModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : DateTime.now(),
      requiredBooks: (json['required_books'] as List<dynamic>? ?? [])
          .map((e) => RequiredBookModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      firstPlacePoints: json['first_place_points'] as int? ?? 0,
      secondPlacePoints: json['second_place_points'] as int? ?? 0,
      thirdPlacePoints: json['third_place_points'] as int? ?? 0,
      participantPoints: json['participant_points'] as int? ?? 0,
      status: json['status'] as String? ?? 'upcoming',
      isRegistered: json['is_registered'] as bool? ?? false,
      userBookProgress: (json['user_book_progress'] as List<dynamic>? ?? [])
          .map((e) => BookProgressModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      userOutcome: json['user_outcome'] as String?,
      userWonDate: json['user_won_date'] != null
          ? DateTime.parse(json['user_won_date'] as String)
          : null,
      userPointsEarned: json['user_points_earned'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'required_books': requiredBooks
          .map((e) => (e as RequiredBookModel).toJson())
          .toList(),
      'first_place_points': firstPlacePoints,
      'second_place_points': secondPlacePoints,
      'third_place_points': thirdPlacePoints,
      'participant_points': participantPoints,
      'status': status,
      'is_registered': isRegistered,
      'user_book_progress': userBookProgress
          .map((e) => (e as BookProgressModel).toJson())
          .toList(),
      'user_outcome': userOutcome,
      'user_won_date': userWonDate?.toIso8601String(),
      'user_points_earned': userPointsEarned,
    };
  }

  static const Object _unset = Object();

  GroupChallengeModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<RequiredBookEntity>? requiredBooks,
    int? firstPlacePoints,
    int? secondPlacePoints,
    int? thirdPlacePoints,
    int? participantPoints,
    String? status,
    bool? isRegistered,
    List<BookProgressEntity>? userBookProgress,
    Object? userOutcome = _unset,
    Object? userWonDate = _unset,
    Object? userPointsEarned = _unset,
  }) {
    return GroupChallengeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      requiredBooks: requiredBooks ?? this.requiredBooks,
      firstPlacePoints: firstPlacePoints ?? this.firstPlacePoints,
      secondPlacePoints: secondPlacePoints ?? this.secondPlacePoints,
      thirdPlacePoints: thirdPlacePoints ?? this.thirdPlacePoints,
      participantPoints: participantPoints ?? this.participantPoints,
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
    );
  }
}