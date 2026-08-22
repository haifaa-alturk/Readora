import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository_interface.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';
import '../models/purchase_history_model.dart';

class ProfileRepositoryImpl implements ProfileRepositoryInterface {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  // ============================================================
  // GET PROFILE
  // ============================================================

  @override
  Future<Either<String, ProfileEntity>> getProfile() async {
    try {
      final ProfileModel result = await _remoteDataSource.getProfile();

      return Right<String, ProfileEntity>(result);
    } on DioException catch (e) {
      return Left<String, ProfileEntity>(_getDioErrorMessage(e));
    } catch (e) {
      return Left<String, ProfileEntity>(
        'حدث خطأ أثناء جلب بيانات المستخدم: ${e.toString()}',
      );
    }
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  @override
  Future<Either<String, ProfileEntity>> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    try {
      final ProfileModel result = await _remoteDataSource.updateProfile(
        name: name,
        email: email,
        imagePath: imagePath,
      );

      return Right<String, ProfileEntity>(result);
    } on DioException catch (e) {
      return Left<String, ProfileEntity>(_getDioErrorMessage(e));
    } catch (e) {
      return Left<String, ProfileEntity>(
        'حدث خطأ أثناء تحديث الملف الشخصي: ${e.toString()}',
      );
    }
  }

  // ============================================================
  // UPDATE PROFILE IMAGE
  // ============================================================

  @override
  Future<Either<String, ProfileEntity>> uploadProfileImage(
    String filePath,
  ) async {
    try {
      final ProfileModel result = await _remoteDataSource.updateProfileImage(
        filePath,
      );

      return Right<String, ProfileEntity>(result);
    } on DioException catch (e) {
      return Left<String, ProfileEntity>(_getDioErrorMessage(e));
    } catch (e) {
      return Left<String, ProfileEntity>(
        'حدث خطأ أثناء تحديث صورة الملف الشخصي: ${e.toString()}',
      );
    }
  }

  // ============================================================
  // PURCHASE HISTORY
  // ============================================================

  Future<Either<String, List<PurchaseHistoryModel>>>
  getPurchaseHistory() async {
    try {
      final result = await _remoteDataSource.getPurchaseHistory();

      return Right<String, List<PurchaseHistoryModel>>(result);
    } on DioException catch (e) {
      return Left<String, List<PurchaseHistoryModel>>(_getDioErrorMessage(e));
    } catch (e) {
      return Left<String, List<PurchaseHistoryModel>>(
        'حدث خطأ أثناء جلب سجل المشتريات: ${e.toString()}',
      );
    }
  }

  // ============================================================
  // DIO ERROR
  // ============================================================

  String _getDioErrorMessage(DioException e) {
    final responseData = e.response?.data;

    if (responseData is Map) {
      final message = responseData['message'];

      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }

      final errors = responseData['errors'];

      if (errors is Map) {
        final messages = <String>[];

        for (final value in errors.values) {
          if (value is List) {
            messages.addAll(value.map((item) => item.toString()));
          } else {
            messages.add(value.toString());
          }
        }

        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال بالخادم';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم، تأكدي أن الباكند يعمل';
    }

    if (e.response?.statusCode == 401) {
      return 'انتهت جلسة تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى';
    }

    if (e.response?.statusCode == 403) {
      return 'ليس لديك صلاحية لتنفيذ هذه العملية';
    }

    if (e.response?.statusCode == 404) {
      return 'الطلب غير موجود على الخادم';
    }

    if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
      return 'حدث خطأ في الخادم';
    }

    return 'حدث خطأ أثناء الاتصال بالخادم';
  }
}
