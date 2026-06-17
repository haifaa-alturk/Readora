import 'package:dio/dio.dart';

import '../models/book_details_model.dart';

abstract class BookDetailsRemoteDataSource {
  Future<BookDetailsModel> getBookDetails(int id);
}

class BookDetailsRemoteDataSourceImpl implements BookDetailsRemoteDataSource {
  final Dio dio;

  BookDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<BookDetailsModel> getBookDetails(int id) async {
    final response = await dio.get('/books/$id');

    return BookDetailsModel.fromJson(response.data);
  }
}
