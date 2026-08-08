class QuoteEntity {
  final int id;
  final int bookId;
  final String bookTitle;
  final String quoteText;
  final DateTime createdAt;

  const QuoteEntity({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.quoteText,
    required this.createdAt,
  });
}