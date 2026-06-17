class BookDetails {
  final int id;

  final String bookName;

  final String description;

  final String language;

  final int pages;

  final String sellingPrice;

  final String coverImage;

  final String pdfFile;

  final List<String> previewPages;

  final List<String> authors;

  final List<String> categories;

  BookDetails({
    required this.id,

    required this.bookName,

    required this.description,

    required this.language,

    required this.pages,

    required this.sellingPrice,

    required this.coverImage,

    required this.pdfFile,

    required this.previewPages,

    required this.authors,

    required this.categories,
  });
}
