import 'package:dartz/dartz.dart';

import '../entities/profile_entity.dart';
import '../entities/purchase_history_entity.dart';

abstract class ProfileRepositoryInterface {
  Future<Either<String, ProfileEntity>> getProfile();
  Future<Either<String, ProfileEntity>> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  });
  Future<Either<String, ProfileEntity>> uploadProfileImage(String filePath);
  Future<Either<String, List<PurchaseHistoryEntity>>> getPurchaseHistory();
}