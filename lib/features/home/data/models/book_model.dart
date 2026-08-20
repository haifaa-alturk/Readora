// import '../../domain/entities/book.dart';

// class BookModel extends Book {
//   BookModel({
//     required super.id,
//     required super.bookName,
//     super.description,
//     super.coverImage,
//     required super.rating,
//     super.sellingPrice,
//     required super.authors,
//   });

//   factory BookModel.fromJson(Map<String, dynamic> json) {
//     try {
//       // 1. معالجة أسماء المؤلفين
//       List<String> authorNames = [];
//       if (json['authors'] != null && json['authors'] is List) {
//         authorNames = (json['authors'] as List)
//             .map((author) => author['author_name']?.toString() ?? 'Unknown')
//             .toList();
//       }

//       // 2. إرجاع الكائن
//       return BookModel(
//         id: json['id'] ?? 0,
//         bookName: json['book_name'] ?? 'بدون عنوان',
//         description: json['description'],
//         coverImage: json['cover_image'],
//         rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
//         sellingPrice: json['selling_price']?.toString(),
//         authors: authorNames,
//       );
//     } catch (e) {
//       // هذا الجزء سيطبع الخطأ في الـ Console إذا حدثت مشكلة في كتاب معين
//       print("❌ Error parsing book: $e");
//       return BookModel(
//         id: 0,
//         bookName: "Error parsing",
//         rating: 0,
//         authors: [],
//       );
//     }
//   } // نهاية الـ factory
// } // نهاية الكلاس
/*
import '../../domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    required super.id,
    required super.bookName,
    super.description,
    super.coverImage,
    required super.rating,
    super.sellingPrice,
    super.pdfFile,
    required super.authors,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    List<String> authorNames = [];

    if (json['authors'] != null && json['authors'] is List) {
      authorNames = (json['authors'] as List)
          .map((author) => author['author_name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    }

    return BookModel(
      id: json['id'],

      bookName: json['book_name'] ?? 'بدون عنوان',

      description: json['description'] ?? '',

      coverImage: json['cover_image'],

      // الباك إند يرجع book_file وليس pdf_file
      pdfFile: json['book_file'],

      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,

      sellingPrice: json['selling_price']?.toString(),

      authors: authorNames,
    );
  }
}
*/
import '../../domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    required super.id,
    required super.bookName,
    super.description,
    super.coverImage,
    required super.rating,
    super.sellingPrice,
    super.pdfFile,
    required super.authors,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    List<String> authorNames = [];

    if (json['authors'] != null) {
      authorNames = (json['authors'] as List)
          .map((author) => author['author_name'].toString())
          .toList();
    }

    return BookModel(
      id: json['id'],
      bookName: json['book_name'] ?? 'بدون عنوان',
      description: json['description'],

      // تحويل مسار صورة الغلاف إلى رابط كامل
      coverImage: _buildFileUrl(json['cover_image']),

      // تحويل مسار PDF إلى رابط كامل
      pdfFile: _buildFileUrl(json['book_file']),

      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,

      sellingPrice: json['selling_price']?.toString(),

      authors: authorNames,
    );
  }

  static String? _buildFileUrl(dynamic value) {
    if (value == null) return null;

    final path = value.toString().trim();

    if (path.isEmpty) return null;

    // إذا كان الرابط كاملاً أصلاً، نعيده كما هو
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // إذا كان مساراً داخل storage، نضيف رابط Laravel
    return 'http://10.66.254.50:8000/storage/${path.replaceFirst(RegExp(r'^/'), '')}';
  }
}
