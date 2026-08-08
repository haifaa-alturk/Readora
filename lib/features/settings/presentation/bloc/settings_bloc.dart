import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/settings_model.dart';
import '../../domain/repositories/settings_repository_interface.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepositoryInterface repository;

  SettingsBloc({required this.repository}) : super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await repository.getSettings();
    result.fold(
      (error) => emit(SettingsError(message: error)),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final updated = current.settings.copyWith(
      notificationsEnabled: !current.settings.notificationsEnabled,
    );

    final result = await repository.updateSettings(
      SettingsModel(
        notificationsEnabled: updated.notificationsEnabled,
        language: updated.language,
      ),
    );
    result.fold(
      (error) => emit(SettingsError(message: error)),
      (_) => emit(SettingsLoaded(settings: updated)),
    );
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    // Token removal is handled by the screen listener
    emit(const LoggedOut());
  }
}