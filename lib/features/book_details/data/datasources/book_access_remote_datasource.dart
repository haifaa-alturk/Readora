import 'package:dio/dio.dart';

abstract class BookAccessRemoteDataSource {
  Future<bool> checkAccess(int bookId);
}

class BookAccessRemoteDataSourceImpl implements BookAccessRemoteDataSource {
  final Dio dio;

  BookAccessRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool> checkAccess(int bookId) async {
    final response = await dio.get('/user/book/$bookId/check_access');

    print("CHECK ACCESS RESPONSE:");
    print(response.data);

    return response.data['has_access'] == true;
  }
}
