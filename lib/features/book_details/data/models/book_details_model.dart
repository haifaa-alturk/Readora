import '../../domain/entities/book_details.dart';

class BookDetailsModel extends BookDetails {
  BookDetailsModel({
    required super.id,
    required super.bookName,
    required super.language,
    required super.description,
    required super.coverImage,
    required super.pages,
    required super.rating,
    required super.pdfFile,
    required super.authors,
    required super.categories,
    required super.sellingPrice,
    required super.rentalPrice,
  });

  static const String _baseUrl = 'http://10.243.228.50:8000';

  static String? _buildFileUrl(dynamic value) {
    if (value == null) return null;

    final path = value.toString().trim();

    if (path.isEmpty) return null;

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    return '$_baseUrl/storage/${path.replaceFirst(RegExp(r'^/'), '')}';
  }

  static double _parseRating(Map<String, dynamic> json) {
    final value =
        json['average_rating'] ?? json['avg_rating'] ?? json['rating'] ?? 0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory BookDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> authorNames = [];

    if (json['authors'] != null) {
      authorNames = (json['authors'] as List)
          .map((author) => author['author_name'].toString())
          .toList();
    }

    List<String> categoryNames = [];

    if (json['categories'] != null) {
      categoryNames = (json['categories'] as List)
          .map((category) => category['name'].toString())
          .toList();
    }

    return BookDetailsModel(
      id: json['id'] ?? 0,

      bookName: json['book_name']?.toString() ?? '',

      language: json['language']?.toString() ?? '',

      description: json['description']?.toString() ?? '',

      coverImage: _buildFileUrl(json['cover_image']) ?? '',

      pages: int.tryParse(json['number_of_pages']?.toString() ?? '0') ?? 0,

      // ======================================================
      // متوسط تقييم الكتاب
      // ======================================================
      rating: _parseRating(json),

      pdfFile: _buildFileUrl(json['book_file']),

      authors: authorNames,

      categories: categoryNames,

      sellingPrice:
          double.tryParse(json['selling_price']?.toString() ?? '0') ?? 0,

      rentalPrice:
          double.tryParse(json['rental_price']?.toString() ?? '0') ?? 0,
    );
  }
}
