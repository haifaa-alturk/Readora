import 'package:dio/dio.dart';

abstract class RatingRemoteDataSource {
  Future<void> rateBook({required int bookId, required int rating});

  Future<void> updateRating({required int bookId, required int rating});
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final Dio dio;

  RatingRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> rateBook({required int bookId, required int rating}) async {
    final response = await dio.post(
      '/ratings/$bookId',
      data: {'rating': rating},
    );

    print('⭐ Rating Response:');
    print(response.data);
  }

  @override
  Future<void> updateRating({required int bookId, required int rating}) async {
    final response = await dio.put(
      '/ratings/$bookId',
      data: {'rating': rating},
    );

    print('✏️ Update Rating Response:');
    print(response.data);
  }
}
