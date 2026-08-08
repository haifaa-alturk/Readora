import '../../domain/entities/group_challenge_entity.dart';

class GroupChallengeModel extends GroupChallengeEntity {
  const GroupChallengeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.bonusPoints,
    required super.requiredBooks,
    required super.requiredQuizzes,
    required super.deadline,
    required super.isJoined,
    required super.userBooksCompleted,
    required super.userQuizzesPassed,
    required super.status,
  });

  factory GroupChallengeModel.fromJson(Map<String, dynamic> json) {
    return GroupChallengeModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      bonusPoints: json['bonus_points'] as int? ?? 0,
      requiredBooks: json['required_books'] as int? ?? 0,
      requiredQuizzes: json['required_quizzes'] as int? ?? 0,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : DateTime.now(),
      isJoined: json['is_joined'] as bool? ?? false,
      userBooksCompleted: json['user_books_completed'] as int? ?? 0,
      userQuizzesPassed: json['user_quizzes_passed'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'bonus_points': bonusPoints,
      'required_books': requiredBooks,
      'required_quizzes': requiredQuizzes,
      'deadline': deadline.toIso8601String(),
      'is_joined': isJoined,
      'user_books_completed': userBooksCompleted,
      'user_quizzes_passed': userQuizzesPassed,
      'status': status,
    };
  }
}
