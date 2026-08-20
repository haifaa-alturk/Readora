import 'package:dio/dio.dart';

abstract class BookActionRemoteDataSource {
  Future<void> purchaseBook({
    required int bookId,
    required String discountPackage,
  });

  Future<void> borrowBook({
    required int bookId,
    required String discountPackage,
  });
}

class BookActionRemoteDataSourceImpl implements BookActionRemoteDataSource {
  final Dio dio;

  BookActionRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> purchaseBook({
    required int bookId,
    required String discountPackage,
  }) async {
    final response = await dio.post(
      '/user/book/purchase',
      data: {'book_id': bookId, 'discount_package': discountPackage},
    );

    print("PURCHASE RESPONSE:");
    print(response.data);
  }

  @override
  Future<void> borrowBook({
    required int bookId,
    required String discountPackage,
  }) async {
    final response = await dio.post(
      '/user/book/borrow',
      data: {'book_id': bookId, 'discount_package': discountPackage},
    );

    print("BORROW RESPONSE:");
    print(response.data);
  }
}
