import 'package:dartz/dartz.dart';
import '../entities/book.dart';
import '../repositories/home_repository.dart';

class GetHomeBooks {
  final HomeRepository repository;
  GetHomeBooks(this.repository);

  Future<Either<String, List<Book>>> executeRecommended() => repository.getRecommendedBooks();
  Future<Either<String, List<Book>>> executeTopRated() => repository.getTopRatedBooks();
  Future<Either<String, List<Book>>> executeNew() => repository.getNewBooks();
}