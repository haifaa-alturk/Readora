// import 'package:equatable/equatable.dart';

// abstract class SettingsEvent extends Equatable {
//   const SettingsEvent();

//   @override
//   List<Object?> get props => [];
// }

// class LoadSettingsEvent extends SettingsEvent {
//   const LoadSettingsEvent();
// }

// class ToggleNotificationsEvent extends SettingsEvent {
//   const ToggleNotificationsEvent();
// }

// class LogoutRequested extends SettingsEvent {
//   const LogoutRequested();
// }
import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class ToggleNotificationsEvent extends SettingsEvent {
  const ToggleNotificationsEvent();
}

// 🔴 حدث تغيير اللغة (مثلاً 'en' أو 'ar')
class ChangeLanguageEvent extends SettingsEvent {
  final String language;
  const ChangeLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}

// 🔴 حدث تغيير الثيم (الوضع الداكن / الفاتح)
class ToggleThemeEvent extends SettingsEvent {
  final bool isDarkMode;
  const ToggleThemeEvent(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

class LogoutRequested extends SettingsEvent {
  const LogoutRequested();
}