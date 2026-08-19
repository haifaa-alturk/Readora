import 'package:dartz/dartz.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/purchase_history_entity.dart';
import '../../domain/repositories/profile_repository_interface.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepositoryInterface {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, ProfileEntity>> getProfile() async {
    try {
      final result = await _remoteDataSource.getProfile();
      return Right(result);
    } catch (e) {
      return Left('Error fetching profile: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ProfileEntity>> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    try {
      final result = await _remoteDataSource.updateProfile(
        name: name,
        email: email,
        imagePath: imagePath,
      );
      return Right(result);
    } catch (e) {
      return Left('Error updating profile: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ProfileEntity>> uploadProfileImage(String filePath) async {
    try {
      final result = await _remoteDataSource.updateProfileImage(filePath);
      return Right(result);
    } catch (e) {
      return Left('Error uploading image: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<PurchaseHistoryEntity>>> getPurchaseHistory() async {
    try {
      final result = await _remoteDataSource.getPurchaseHistory();
      return Right(result);
    } catch (e) {
      return Left('Error fetching purchase history: ${e.toString()}');
    }
  }
}