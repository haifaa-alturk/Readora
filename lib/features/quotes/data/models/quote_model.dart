import '../../domain/entities/quote_entity.dart';

class QuoteModel extends QuoteEntity {
  const QuoteModel({
    required super.id,
    required super.bookId,
    required super.bookTitle,
    required super.quoteText,
    required super.createdAt,
  });

  // ============================================================
  // FROM JSON
  // ============================================================

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: _parseInt(json['id']),

      bookId: _parseInt(json['book_id'] ?? json['bookId']),

      bookTitle:
          json['book_title']?.toString() ??
          json['bookTitle']?.toString() ??
          'Unknown Book',

      quoteText:
          json['quote_text']?.toString() ?? json['quoteText']?.toString() ?? '',

      createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'book_title': bookTitle,
      'quote_text': quoteText,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // ============================================================
  // HELPERS
  // ============================================================

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }

    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}
