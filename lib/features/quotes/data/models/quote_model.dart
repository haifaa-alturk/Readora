import '../../domain/entities/quote_entity.dart';

class QuoteModel extends QuoteEntity {
  const QuoteModel({
    required super.id,
    required super.bookId,
    required super.bookTitle,
    required super.quoteText,
    required super.createdAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as int,
      bookId: json['book_id'] as int,
      bookTitle: json['book_title'] as String,
      quoteText: json['quote_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'book_title': bookTitle,
      'quote_text': quoteText,
      'created_at': createdAt.toIso8601String(),
    };
  }
}