class Book {
  final int id;
  final String bookName;
  final String? description;
  final String? coverImage;
  final double rating;
  final String? sellingPrice;
  final List<String> authors; // سنخزن أسماء المؤلفين هنا

  Book({
    required this.id,
    required this.bookName,
    this.description,
    this.coverImage,
    required this.rating,
    this.sellingPrice,
    required this.authors,
  });
}