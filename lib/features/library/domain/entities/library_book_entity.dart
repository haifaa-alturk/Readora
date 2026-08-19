class LibraryBookEntity {
  final int id;
  final String title;
  final String author;
  final String status;
  final String? displayDate;

  const LibraryBookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    this.displayDate,
  });
}