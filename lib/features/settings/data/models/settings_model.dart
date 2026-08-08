import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    super.notificationsEnabled,
    super.language,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled,
      'language': language,
    };
  }
}