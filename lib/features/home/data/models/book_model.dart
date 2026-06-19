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
    // معالجة أسماء المؤلفين من العلاقة authors بالباك إند
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

      // صورة الغلاف
      coverImage: json['cover_image'],

      // رابط ملف PDF
      pdfFile: json['pdf_file'],

      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,

      sellingPrice: json['selling_price']?.toString(),

      authors: authorNames,
    );
  }
}
