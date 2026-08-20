import 'package:dartz/dartz.dart';

import '../repositories/book_access_repository.dart';

class CheckBookAccess {
  final BookAccessRepository repository;

  CheckBookAccess(this.repository);

  Future<Either<String, bool>> call(int bookId) async {
    return await repository.checkAccess(bookId);
  }
}
