import '../../domain/entities/library_book_entity.dart';

class LibraryBookModel extends LibraryBookEntity {
  const LibraryBookModel({
    required super.id,
    required super.title,
    required super.author,
    super.startDate,
    super.completionDate,
    required super.status,
  });

  factory LibraryBookModel.fromJson(Map<String, dynamic> json) {
    return LibraryBookModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      completionDate: json['completion_date'] != null
          ? DateTime.parse(json['completion_date'] as String)
          : null,
      status: json['status'] as String? ?? 'in_progress',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'start_date': startDate?.toIso8601String(),
      'completion_date': completionDate?.toIso8601String(),
      'status': status,
    };
  }
}