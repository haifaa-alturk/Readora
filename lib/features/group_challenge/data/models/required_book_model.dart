import '../../domain/entities/required_book_entity.dart';

class RequiredBookModel extends RequiredBookEntity {
  const RequiredBookModel({
    required super.bookId,
    required super.title,
    super.coverUrl,
  });

  factory RequiredBookModel.fromJson(Map<String, dynamic> json) {
    return RequiredBookModel(
      bookId: json['book_id'] as int,
      title: json['title'] as String? ?? '',
      coverUrl: json['cover_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_id': bookId,
      'title': title,
      'cover_url': coverUrl,
    };
  }
}