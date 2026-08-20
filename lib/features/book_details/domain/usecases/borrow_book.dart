import 'package:dartz/dartz.dart';

import '../repositories/book_action_repository.dart';

class BorrowBook {
  final BookActionRepository repository;

  BorrowBook(this.repository);

  Future<Either<String, bool>> call({
    required int bookId,
    required String discountPackage,
  }) async {
    return await repository.borrowBook(
      bookId: bookId,
      discountPackage: discountPackage,
    );
  }
}
