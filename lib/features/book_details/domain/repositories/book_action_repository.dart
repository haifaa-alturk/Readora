import 'package:dartz/dartz.dart';

abstract class BookActionRepository {
  Future<Either<String, bool>> purchaseBook({
    required int bookId,
    required String discountPackage,
  });

  Future<Either<String, bool>> borrowBook({
    required int bookId,
    required String discountPackage,
  });
}
