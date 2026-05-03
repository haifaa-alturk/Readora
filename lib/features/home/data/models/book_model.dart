import '../../domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    required super.id,
    required super.bookName,
    super.description,
    super.coverImage,
    required super.rating,
    super.sellingPrice,
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
      // الروابط في اللارافيل تحتاج أحياناً لإضافة رابط السيرفر قبلها
      coverImage: json['cover_image'], 
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      sellingPrice: json['selling_price']?.toString(),
      authors: authorNames,
    );
  }
}