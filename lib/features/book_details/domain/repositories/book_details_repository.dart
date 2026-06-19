import 'package:dartz/dartz.dart';

import '../entities/book_details.dart';

abstract class BookDetailsRepository {
  Future<Either<String, BookDetails>> getBookDetails(int id);

}
