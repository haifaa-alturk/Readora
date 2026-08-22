import 'package:dartz/dartz.dart';

abstract class BookAccessRepository {
  Future<Either<String, bool>> checkAccess(int bookId);
}
