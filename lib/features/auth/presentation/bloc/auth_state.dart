// import 'package:library_app1/features/auth/data/models/user_model.dart';
// // import 'package:library_app1/users/models/user_model.dart';

// abstract class AuthState {}

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class LoginSuccess extends AuthState {
//   final UserModel user;
//   final String token;

//   LoginSuccess({
//     required this.user,
//     required this.token,
//   });
// }

// class SignupSuccess extends AuthState {}

// class ForgotPasswordSuccess extends AuthState {}

// class AuthError extends AuthState {
//   final String message;

//   AuthError(this.message);
// }

import 'package:library_app1/features/auth/data/models/Category_Model.dart';

import '../../domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class CategoriesLoading extends AuthState {}
class CategoriesLoaded extends AuthState {
  final List<CategoryModel> categories;
  CategoriesLoaded(this.categories);
}