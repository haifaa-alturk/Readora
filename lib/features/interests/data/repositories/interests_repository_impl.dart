import 'package:dartz/dartz.dart';

import '../../domain/entities/interest_entity.dart';
import '../../domain/repositories/interests_repository_interface.dart';
import '../datasources/interests_remote_datasource.dart';

class InterestsRepositoryImpl implements InterestsRepositoryInterface {
  final InterestsRemoteDataSource _remoteDataSource;

  InterestsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<InterestEntity>>> getAllInterests() async {
    try {
      final result = await _remoteDataSource.getAllInterests();
      return Right(result);
    } catch (e) {
      return Left('Error fetching interests: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<InterestEntity>>> updateUserInterests(
      List<int> selectedInterestIds) async {
    try {
      final result =
          await _remoteDataSource.updateUserInterests(selectedInterestIds);
      return Right(result);
    } catch (e) {
      return Left('Error updating interests: ${e.toString()}');
    }
  }
}