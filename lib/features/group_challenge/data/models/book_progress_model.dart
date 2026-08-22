import '../../domain/entities/book_progress_entity.dart';

class BookProgressModel extends BookProgressEntity {
  const BookProgressModel({
    required super.bookId,
    required super.title,
    required super.isCompleted,
    required super.isFailed,
  });

  /// Parses a book (with optional progress) from the real backend shape:
  /// { id, book_name, status: "finished" | "not_finished", finished_at, ... }
  /// When the user hasn't joined the event, books arrive as the plain
  /// event.books list with no "status" key — treat them as not completed.
  factory BookProgressModel.fromJson(Map<String, dynamic> json) {
    return BookProgressModel(
      bookId: json['id'] as int? ?? 0,
      title: json['book_name'] as String? ?? '',
      isCompleted: json['status'] == 'finished',
      // The backend has no "failed" state — participation_books.status is
      // only "finished" | "not_finished". Do NOT re-add fake fail logic.
      isFailed: false,
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