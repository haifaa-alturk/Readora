
import 'package:equatable/equatable.dart';
import '../../domain/entities/settings_entity.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

// class SettingsLoaded extends SettingsState {
//   final SettingsEntity settings;
//   final String language; // 🔴 'en' or 'ar'
//   final bool isDarkMode; // 🔴 true for dark, false for light

//   const SettingsLoaded({
//     required this.settings,
//     this.language = 'en',
//     this.isDarkMode = false,
//   });

//   SettingsLoaded copyWith({
//     SettingsEntity? settings,
//     String? language,
//     bool? isDarkMode,
//   }) {
//     return SettingsLoaded(
//       settings: settings ?? this.settings,
//       language: language ?? this.language,
//       isDarkMode: isDarkMode ?? this.isDarkMode,
//     );
//   }

//   @override
//   List<Object?> get props => [settings, language, isDarkMode];
// }
class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;
  final String language; // 'en' or 'ar'
  final bool isDarkMode; // true for dark, false for light

  // 💡 التعديل: إزالة القيم الافتراضية لجعل التمرير إجبارياً من الـ Bloc
  const SettingsLoaded({
    required this.settings,
    required this.language,
    required this.isDarkMode,
  });

  SettingsLoaded copyWith({
    SettingsEntity? settings,
    String? language,
    bool? isDarkMode,
  }) {
    return SettingsLoaded(
      settings: settings ?? this.settings,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [settings, language, isDarkMode];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoggedOut extends SettingsState {
  const LoggedOut();
}