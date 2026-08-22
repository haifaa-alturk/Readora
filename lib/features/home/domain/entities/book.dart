class Book {
  final int id;
  final String bookName;
  final String? description;
  final String? coverImage;
  final double rating;
  final String? sellingPrice;
  final String? rentalPrice;
  final String? pdfFile;
  final String? language;
  final int? numberOfPages;
  final List<Author> authors;
  final List<Category> categories;

  Book({
    required this.id,
    required this.bookName,
    this.description,
    this.coverImage,
    required this.rating,
    this.sellingPrice,
    this.rentalPrice,
    this.pdfFile,
    this.language,
    this.numberOfPages,
    required this.authors,
    required this.categories,
  });

  // ============================================================
  // AUTHORS NAMES
  // ============================================================

  String get authorsText {
    if (authors.isEmpty) {
      return "مؤلف غير معروف";
    }

    return authors
        .map((author) => author.authorName.trim())
        .where((name) => name.isNotEmpty)
        .join(", ");
  }

  // ============================================================
  // CATEGORIES NAMES
  // ============================================================

  String get categoriesText {
    if (categories.isEmpty) {
      return "";
    }

    return categories
        .map((category) => category.categoryName.trim())
        .where((name) => name.isNotEmpty)
        .join(", ");
  }

  // ============================================================
  // SELLING PRICE
  // ============================================================

  double get sellingPriceValue {
    return double.tryParse(sellingPrice ?? '0') ?? 0.0;
  }

  // ============================================================
  // RENTAL PRICE
  // ============================================================

  double get rentalPriceValue {
    return double.tryParse(rentalPrice ?? '0') ?? 0.0;
  }
}

// ============================================================
// AUTHOR
// ============================================================

class Author {
  final int id;
  final String authorName;

  Author({required this.id, required this.authorName});
}

// ============================================================
// CATEGORY
// ============================================================

class Category {
  final int id;
  final String categoryName;

  Category({required this.id, required this.categoryName});
}
