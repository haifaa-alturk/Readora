import 'package:dartz/dartz.dart';

import '../../domain/repositories/book_access_repository.dart';
import '../datasources/book_access_remote_datasource.dart';

class BookAccessRepositoryImpl implements BookAccessRepository {
  final BookAccessRemoteDataSource remoteDataSource;

  BookAccessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, bool>> checkAccess(int bookId) async {
    try {
      final result = await remoteDataSource.checkAccess(bookId);

      return Right(result);
    } catch (e) {
      print("Failed to check book access: $e");

      return Left(e.toString());
    }
  }
}
