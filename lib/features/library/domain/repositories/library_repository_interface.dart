import 'package:dartz/dartz.dart';

import '../entities/library_book_entity.dart';

abstract class LibraryRepositoryInterface {
  Future<Either<String, List<LibraryBookEntity>>> getUserBooks();
}