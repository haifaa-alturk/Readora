class BookProgressEntity {
  final int bookId;
  final String title;
  final bool isCompleted;
  final bool isFailed;

  const BookProgressEntity({
    required this.bookId,
    required this.title,
    required this.isCompleted,
    required this.isFailed,
  });
}