import 'package:dartz/dartz.dart';

import '../repositories/book_action_repository.dart';

class PurchaseBook {
  final BookActionRepository repository;

  PurchaseBook(this.repository);

  Future<Either<String, bool>> call({
    required int bookId,
    required String discountPackage,
  }) async {
    return await repository.purchaseBook(
      bookId: bookId,
      discountPackage: discountPackage,
    );
  }
}
