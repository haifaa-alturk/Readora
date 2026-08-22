import '../../domain/entities/required_book_entity.dart';

class RequiredBookModel extends RequiredBookEntity {
  const RequiredBookModel({
    required super.bookId,
    required super.title,
    super.coverUrl,
  });

  /// Parses a Book object from the Laravel `books` relation:
  /// { id, book_name, cover_image, ... }
  factory RequiredBookModel.fromJson(Map<String, dynamic> json) {
    return RequiredBookModel(
      bookId: json['id'] as int? ?? 0,
      title: json['book_name'] as String? ?? '',
      coverUrl: json['cover_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': bookId,
      'book_name': title,
      'cover_image': coverUrl,
    };
  }
}
