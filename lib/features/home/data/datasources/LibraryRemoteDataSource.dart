import 'package:dio/dio.dart';
import '../models/book_model.dart';

abstract class LibraryRemoteDataSource {
  Future<List<BookModel>> getAllBooks();
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final Dio dio;
  LibraryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BookModel>> getAllBooks() async {
    //  راوت عرض جميع الكتب مرتبة من الأحدث للأقدم
    final response = await dio.get('/books');
    return (response.data as List).map((e) => BookModel.fromJson(e)).toList();
  }
}