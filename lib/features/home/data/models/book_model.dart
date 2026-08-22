import '../../domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    required super.id,
    required super.bookName,
    super.description,
    super.coverImage,
    required super.rating,
    super.sellingPrice,
    super.rentalPrice,
    super.pdfFile,
    super.language,
    super.numberOfPages,
    required super.authors,
    required super.categories,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    // ==========================================================
    // AUTHORS
    // ==========================================================

    List<Author> authorsList = [];

    if (json['authors'] != null && json['authors'] is List) {
      authorsList = (json['authors'] as List).map<Author>((author) {
        return Author(
          id: author['id'] ?? 0,
          authorName: author['author_name']?.toString() ?? 'Unknown Author',
        );
      }).toList();
    }

    // ==========================================================
    // CATEGORIES
    // ==========================================================

    List<Category> categoriesList = [];

    if (json['categories'] != null && json['categories'] is List) {
      categoriesList = (json['categories'] as List).map<Category>((category) {
        return Category(
          id: category['id'] ?? 0,
          categoryName:
              category['category_name']?.toString() ?? 'Unknown Category',
        );
      }).toList();
    }

    // ==========================================================
    // BOOK MODEL
    // ==========================================================

    return BookModel(
      id: json['id'] ?? 0,

      bookName: json['book_name']?.toString() ?? 'بدون عنوان',

      description: json['description']?.toString(),

      // COVER
      coverImage: _buildFileUrl(json['cover_image']),

      // PDF
      pdfFile: _buildFileUrl(json['book_file']),

      // RATING
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,

      // BUY PRICE
      sellingPrice: json['selling_price']?.toString(),

      // RENT PRICE
      rentalPrice: json['rental_price']?.toString(),

      // LANGUAGE
      language: json['language']?.toString(),

      // NUMBER OF PAGES
      numberOfPages: _parseInt(json['number_of_pages']),

      // AUTHORS
      authors: authorsList,

      // CATEGORIES
      categories: categoriesList,
    );
  }

  // ============================================================
  // PARSE INT
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }

  // ============================================================
  // BUILD FILE URL
  // ============================================================

  static String? _buildFileUrl(dynamic value) {
    if (value == null) {
      return null;
    }

    final path = value.toString().trim();

    if (path.isEmpty) {
      return null;
    }

    // الرابط كامل أصلاً
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // رابط Laravel Storage
    return 'http://10.243.228.50:8000/storage/'
        '${path.replaceFirst(RegExp(r'^/'), '')}';
  }
}
