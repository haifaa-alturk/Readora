class Book {
  final int id;
  final String bookName;
  final String? description;
  final String? coverImage;
  final double rating;
  final String? sellingPrice;
  final String? pdfFile; // رابط ملف الكتاب
  final List<String> authors;

  Book({
    required this.id,
    required this.bookName,
    this.description,
    this.coverImage,
    required this.rating,
    this.sellingPrice,
    this.pdfFile,
    required this.authors,
  });
}
