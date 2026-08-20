import 'package:library_app1/features/auth/data/models/Category_Model.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final String? fcmToken;

  LoginEvent(this.email, this.password, this.fcmToken);
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final List<int> interests;
  final String? fcmToken;
  final String? imagePath;

  RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.interests,
    this.imagePath,
    this.fcmToken,
  });
}

class GetCategoriesEvent extends AuthEvent {}

class UpdateUserInterestsEvent extends AuthEvent {
  final List<CategoryModel> interests;

  UpdateUserInterestsEvent(this.interests);
}

class LogoutEvent extends AuthEvent {}
