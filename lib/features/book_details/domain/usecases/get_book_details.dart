import 'package:dartz/dartz.dart';

import '../entities/book_details.dart';
import '../repositories/book_details_repository.dart';

class GetBookDetails {
  final BookDetailsRepository repository;

  GetBookDetails(this.repository);

  Future<Either<String, BookDetails>> call(int id) async {
    return await repository.getBookDetails(id);
  }
}
