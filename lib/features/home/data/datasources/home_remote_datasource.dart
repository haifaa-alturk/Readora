import 'package:dio/dio.dart';
import '../models/book_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<BookModel>> getRecommendedBooks();

  Future<List<BookModel>> getTopRatedBooks();

  Future<List<BookModel>> getNewBooks();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BookModel>> getRecommendedBooks() async {
    final response = await dio.get('books/recommended');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getTopRatedBooks() async {
    final response = await dio.get('books/top-rated');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getNewBooks() async {
    // ن يعيد 30 كتاب مضاف حديثا
    final response = await dio.get('books/new');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }
}
