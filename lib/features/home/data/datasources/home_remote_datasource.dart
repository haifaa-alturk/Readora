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
    final userResponse = await dio.get('/user');

    print("👤 USER FROM BACKEND: ${userResponse.data}");

    final response = await dio.get('/books/recommended');

    print("📚 RECOMMENDED BOOKS FROM SERVER: ${response.data}");

    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getTopRatedBooks() async {
    final response = await dio.get('/books/top-rated');

    print("⭐ TOP RATED BOOKS FROM SERVER: ${response.data}");

    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getNewBooks() async {
    final response = await dio.get('/books/new');

    print("📡 NEW BOOKS FROM SERVER: ${response.data}");

    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }
}
