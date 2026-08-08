import 'package:dartz/dartz.dart';

import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository_interface.dart';
import '../datasources/settings_remote_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepositoryInterface {
  final SettingsRemoteDataSource _remoteDataSource;

  SettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, SettingsEntity>> getSettings() async {
    try {
      final result = await _remoteDataSource.getSettings();
      return Right(result);
    } catch (e) {
      return Left('Error fetching settings: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, SettingsEntity>> updateSettings(
      SettingsEntity settings) async {
    try {
      final result = await _remoteDataSource.updateSettings(
        settings is SettingsModel
            ? settings
            : SettingsModel(
                notificationsEnabled: settings.notificationsEnabled,
                language: settings.language,
              ),
      );
      return Right(result);
    } catch (e) {
      return Left('Error updating settings: ${e.toString()}');
    }
  }
}