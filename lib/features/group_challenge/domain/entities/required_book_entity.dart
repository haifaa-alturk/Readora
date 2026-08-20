class RequiredBookEntity {
  final int bookId;
  final String title;
  final String? coverUrl;

  const RequiredBookEntity({
    required this.bookId,
    required this.title,
    this.coverUrl,
  });
}