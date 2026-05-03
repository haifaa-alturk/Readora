import 'package:dio/dio.dart';
import '../models/book_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<BookModel>> getRecommendedBooks(); // حسب الاهتمامات
  Future<List<BookModel>> getTopRatedBooks();    // أعلى تقييم
  Future<List<BookModel>> getNewBooks();         // الأحدث (جميع الكتب)
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BookModel>> getRecommendedBooks() async {
    final response = await dio.get('/books/recommended');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getTopRatedBooks() async {
    final response = await dio.get('/books/top-rated');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getNewBooks() async {
    // نستخدم الـ endpoint الذي يعيد جميع الكتب مرتبة
    final response = await dio.get('/books');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }
}