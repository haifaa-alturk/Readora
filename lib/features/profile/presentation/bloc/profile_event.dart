import 'dart:io' show File;

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

class UpdateProfileRequested extends ProfileEvent {
  final String newName;
  final String newEmail;
  final File? newImage;

  const UpdateProfileRequested({
    required this.newName,
    required this.newEmail,
    this.newImage,
  });

  @override
  List<Object?> get props => [newName, newEmail, newImage];
}