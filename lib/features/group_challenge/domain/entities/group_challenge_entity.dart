import 'required_book_entity.dart';
import 'book_progress_entity.dart';

class GroupChallengeEntity {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<RequiredBookEntity> requiredBooks;
  final int firstPlacePoints;
  final int secondPlacePoints;
  final int thirdPlacePoints;
  final int participantPoints;
  final String status; // 'upcoming' | 'current' | 'ended'
  final bool isRegistered;
  final List<BookProgressEntity> userBookProgress;
  final String? userOutcome; // null | 'registered' | 'ongoing' | 'won' | 'lost'
  final DateTime? userWonDate;
  final int? userPointsEarned;

  const GroupChallengeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.requiredBooks,
    required this.firstPlacePoints,
    required this.secondPlacePoints,
    required this.thirdPlacePoints,
    required this.participantPoints,
    required this.status,
    required this.isRegistered,
    required this.userBookProgress,
    this.userOutcome,
    this.userWonDate,
    this.userPointsEarned,
  });
}