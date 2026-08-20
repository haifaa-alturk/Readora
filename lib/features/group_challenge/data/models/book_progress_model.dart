import '../../domain/entities/book_progress_entity.dart';

class BookProgressModel extends BookProgressEntity {
  const BookProgressModel({
    required super.bookId,
    required super.title,
    required super.isCompleted,
    required super.isFailed,
  });

  factory BookProgressModel.fromJson(Map<String, dynamic> json) {
    return BookProgressModel(
      bookId: json['book_id'] as int,
      title: json['title'] as String? ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,
      isFailed: json['is_failed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_id': bookId,
      'title': title,
      'is_completed': isCompleted,
      'is_failed': isFailed,
    };
  }
}