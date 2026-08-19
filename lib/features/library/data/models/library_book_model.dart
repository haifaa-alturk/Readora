import '../../domain/entities/library_book_entity.dart';

class LibraryBookModel extends LibraryBookEntity {
  const LibraryBookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.status,
    super.displayDate,
  });

  factory LibraryBookModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? '';
    final status = type.toLowerCase() == 'rent' ? 'borrowed' : 'purchased';

    return LibraryBookModel(
      id: json['book_id'] as int? ?? 0,
      title: json['book_name'] as String? ?? '',
      author: json['authors'] as String? ?? '',
      status: status,
      displayDate: json['date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_id': id,
      'book_name': title,
      'authors': author,
      'status': status,
      'date': displayDate,
    };
  }
}