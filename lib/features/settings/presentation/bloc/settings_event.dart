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

class LogoutRequested extends SettingsEvent {
  const LogoutRequested();
}