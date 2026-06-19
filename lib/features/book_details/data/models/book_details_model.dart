// import '../../domain/entities/book_details.dart';

// class BookDetailsModel extends BookDetails {
//   BookDetailsModel({
//     required super.id,

//     required super.bookName,

//     required super.description,

//     required super.language,

//     required super.pages,

//     required super.sellingPrice,

//     required super.coverImage,

//     required super.pdfFile,

//     required super.previewPages,

//     required super.authors,

//     required super.categories,
//   });

//   factory BookDetailsModel.fromJson(Map<String, dynamic> json) {
//     return BookDetailsModel(
//       id: json['id'],

//       bookName: json['book_name'] ?? 'بدون عنوان',

//       description: json['description'] ?? '',

//       language: json['language'] ?? '',

//       pages: json['pages'] ?? 0,

//       sellingPrice: json['selling_price'].toString(),

//       coverImage: json['cover_image'] ?? '',

//       pdfFile: json['pdf_file'] ?? '',

//       previewPages: json['preview_pages'] != null
//           ? List<String>.from(json['preview_pages'])
//           : [],

//       authors: json['authors'] != null
//           ? (json['authors'] as List)
//                 .map((e) => e['author_name'].toString())
//                 .toList()
//           : [],

//       categories: json['categories'] != null
//           ? (json['categories'] as List)
//                 .map((e) => e['name'].toString())
//                 .toList()
//           : [],
//     );
//   }
// }
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
    required super.authors,
    required super.categories,
  });

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

      bookName: json['book_name'] ?? '',

      language: json['language'] ?? '',

      description: json['description'] ?? '',

      coverImage: json['cover_image'] ?? '',

      pages: json['number_of_pages'] ?? 0,

      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0,

      authors: authorNames,

      categories: categoryNames,
    );
  }
}