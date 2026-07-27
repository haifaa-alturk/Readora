class SettingsEntity {
  final bool notificationsEnabled;
  final String language;

  const SettingsEntity({
    this.notificationsEnabled = true,
    this.language = 'en',
  });

  SettingsEntity copyWith({
    bool? notificationsEnabled,
    String? language,
  }) {
    return SettingsEntity(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }
}