import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/profile_repository_interface.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepositoryInterface repository;

  ProfileBloc({required this.repository}) : super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileRequested>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await repository.getProfile();
    result.fold(
      (error) => emit(ProfileError(message: error)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    emit(const ProfileLoading());

    if (event.newImage != null) {
      final uploadResult = await repository.uploadProfileImage(event.newImage!.path);
      if (uploadResult.isLeft()) {
        uploadResult.fold(
          (error) => emit(ProfileUpdateError(message: error)),
          (_) {},
        );
        return;
      }
    }

    final result = await repository.updateProfile(
      name: event.newName,
      email: event.newEmail,
    );
    result.fold(
      (error) => emit(ProfileUpdateError(message: error)),
      (updatedProfile) {
        emit(ProfileUpdateSuccess(profile: updatedProfile));
        emit(ProfileLoaded(profile: updatedProfile));
      },
    );
  }
}