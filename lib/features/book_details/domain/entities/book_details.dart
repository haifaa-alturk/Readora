class BookDetails {
  final int id;
  final String bookName;
  final String language;
  final String description;
  final String coverImage;
  final int pages;
  final double rating;
  final String? pdfFile;

  final List<String> authors;
  final List<String> categories;

  final double sellingPrice;
  final double rentalPrice;

  BookDetails({
    required this.id,
    required this.bookName,
    required this.language,
    required this.description,
    required this.coverImage,
    required this.pages,
    required this.rating,
    required this.pdfFile,
    required this.authors,
    required this.categories,
    required this.sellingPrice,
    required this.rentalPrice,
  });

  bool? get isFavorite => null;
}
