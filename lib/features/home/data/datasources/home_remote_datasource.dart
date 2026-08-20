/*import 'package:dio/dio.dart';
import '../models/book_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<BookModel>> getRecommendedBooks(); // حسب الاهتمامات
  Future<List<BookModel>> getTopRatedBooks(); // أعلى تقييم
  Future<List<BookModel>> getNewBooks(); // الأحدث (جميع الكتب)
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSourceImpl({required this.dio});

  /*@override
  Future<List<BookModel>> getRecommendedBooks() async {
    final response = await dio.get('/books/recommended');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }*/
  @override
  Future<List<BookModel>> getRecommendedBooks() async {
    // اختبار: هل Laravel يتعرف على المستخدم؟
    final userResponse = await dio.get('/user');

    print("👤 USER FROM BACKEND: ${userResponse.data}");

    final response = await dio.get('/books/recommended');

    print("📚 RECOMMENDED BOOKS FROM SERVER: ${response.data}");

    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getTopRatedBooks() async {
    final response = await dio.get('/books/top-rated');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getNewBooks() async {
    // ن يعيد 30 كتاب مضاف حديثا
    final response = await dio.get('/books/new');
    print("📡 Data from Server: ${response.data}");
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }
}*/
/*
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
    try {
      final userResponse = await dio.get('/user');

      print("👤 USER FROM BACKEND: ${userResponse.data}");

      final response = await dio.get('/books/recommended');

      print("📚 RECOMMENDED BOOKS FROM SERVER: ${response.data}");

      return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ RECOMMENDED ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> getTopRatedBooks() async {
    try {
      final response = await dio.get('/books/top-rated');

      print("⭐ TOP RATED BOOKS FROM SERVER: ${response.data}");

      return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ TOP RATED ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> getNewBooks() async {
    try {
      final response = await dio.get('/books/new');

      print("🆕 NEW BOOKS FROM SERVER: ${response.data}");

      return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ NEW BOOKS ERROR: $e");
      rethrow;
    }
  }
}*/

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

    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }

  @override
  Future<List<BookModel>> getNewBooks() async {
    final response = await dio.get('/books/new');

    print("📡 Data from Server: ${response.data}");

    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }
}
