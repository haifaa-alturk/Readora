import 'package:equatable/equatable.dart';

import 'package:library_app1/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;

  const ProfileUpdateSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateError extends ProfileState {
  final String message;

  const ProfileUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}