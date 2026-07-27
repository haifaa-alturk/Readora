class LibraryBookEntity {
  final int id;
  final String title;
  final String author;
  final DateTime? startDate;
  final DateTime? completionDate;
  final String status;

  const LibraryBookEntity({
    required this.id,
    required this.title,
    required this.author,
    this.startDate,
    this.completionDate,
    required this.status,
  });
}