
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../data/models/settings_model.dart';
// import '../../domain/repositories/settings_repository_interface.dart';
// import 'settings_event.dart';
// import 'settings_state.dart';

// class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
//   final SettingsRepositoryInterface repository;

//   SettingsBloc({required this.repository}) : super(const SettingsInitial()) {
//     on<LoadSettingsEvent>(_onLoadSettings);
//     on<ToggleNotificationsEvent>(_onToggleNotifications);
//     on<ChangeLanguageEvent>(_onChangeLanguage);
//     on<ToggleThemeEvent>(_onToggleTheme);
//     on<LogoutRequested>(_onLogout);
//   }

//   Future<void> _onLoadSettings(
//     LoadSettingsEvent event,
//     Emitter<SettingsState> emit,
//   ) async {
//     emit(const SettingsLoading());

//     final result = await repository.getSettings();
//     result.fold(
//       (error) => emit(SettingsError(message: error)),
//       (settings) => emit(SettingsLoaded(
//         settings: settings,
//         language: settings.language.isNotEmpty ? settings.language : 'en',
//         isDarkMode: false,
//       )),
//     );
//   }

//   Future<void> _onToggleNotifications(
//     ToggleNotificationsEvent event,
//     Emitter<SettingsState> emit,
//   ) async {
//     final current = state;
//     if (current is! SettingsLoaded) return;

//     final updatedSettings = current.settings.copyWith(
//       notificationsEnabled: !current.settings.notificationsEnabled,
//     );

//     final result = await repository.updateSettings(
//       SettingsModel(
//         notificationsEnabled: updatedSettings.notificationsEnabled,
//         language: current.language,
//       ),
//     );

//     result.fold(
//       (error) => emit(SettingsError(message: error)),
//       (_) => emit(current.copyWith(settings: updatedSettings)),
//     );
//   }

//   //  معالجة حدث تغيير اللغة
//   Future<void> _onChangeLanguage(
//     ChangeLanguageEvent event,
//     Emitter<SettingsState> emit,
//   ) async {
//     final current = state;
//     if (current is! SettingsLoaded) return;

//     emit(current.copyWith(language: event.language));
//   }

//   //  معالجة حدث تغيير الوضع الداكن
//   Future<void> _onToggleTheme(
//     ToggleThemeEvent event,
//     Emitter<SettingsState> emit,
//   ) async {
//     final current = state;
//     if (current is! SettingsLoaded) return;

//     emit(current.copyWith(isDarkMode: event.isDarkMode));
//   }

//   Future<void> _onLogout(
//     LogoutRequested event,
//     Emitter<SettingsState> emit,
//   ) async {
 
//     emit(const LoggedOut());
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/settings_model.dart';
import '../../domain/repositories/settings_repository_interface.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepositoryInterface repository;

  SettingsBloc({required this.repository}) : super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LogoutRequested>(_onLogout);
  }

 Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await repository.getSettings();

    // 💡 1. قراءة القيم المحفوظة محلياً
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language_code'); // قد تكون null في أول مرة
    final savedTheme = prefs.getBool('is_dark_mode') ?? false;

    result.fold(
      (error) => emit(SettingsError(message: error)),
      (settings) {
        // 💡 2. الأولوية للغة المحفوظة محلياً، ثم لغة السيرفر، ثم 'en' كخيار أخير
        final effectiveLanguage = savedLang ?? 
            (settings.language.isNotEmpty ? settings.language : 'en');

        emit(SettingsLoaded(
          settings: settings,
          language: effectiveLanguage,
          isDarkMode: savedTheme,
        ));
      },
    );
  }

  Future<void> _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final updatedSettings = current.settings.copyWith(
      notificationsEnabled: !current.settings.notificationsEnabled,
    );

    final result = await repository.updateSettings(
      SettingsModel(
        notificationsEnabled: updatedSettings.notificationsEnabled,
        language: current.language,
      ),
    );

    result.fold(
      (error) => emit(SettingsError(message: error)),
      (_) => emit(current.copyWith(settings: updatedSettings)),
    );
  }

  // 🔴 معالجة حدث تغيير اللغة وحفظه محلياً
  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    // 💡 3. حفظ اللغة الجديدة في SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', event.language);

    emit(current.copyWith(language: event.language));
  }

  // 🔴 معالجة حدث تغيير الوضع الداكن وحفظه محلياً
  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    // 💡 4. حفظ حالة الثيم الجديدة في SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', event.isDarkMode);

    emit(current.copyWith(isDarkMode: event.isDarkMode));
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('is_logged_in');
    // Do NOT remove 'language_code' or 'is_dark_mode' — those are device/UI preferences,
    // not tied to the account, and should survive logout.
    emit(const LoggedOut());
  }
}