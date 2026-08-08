import 'package:dartz/dartz.dart';

import '../../domain/entities/library_book_entity.dart';
import '../../domain/repositories/library_repository_interface.dart';
import '../datasources/library_remote_datasource.dart';

class LibraryRepositoryImpl implements LibraryRepositoryInterface {
  final LibraryRemoteDataSource _remoteDataSource;

  LibraryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<LibraryBookEntity>>> getUserBooks() async {
    try {
      final result = await _remoteDataSource.getUserBooks();
      return Right(result);
    } catch (e) {
      return Left('Error fetching library books: ${e.toString()}');
    }
  }
}