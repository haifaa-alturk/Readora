import 'package:library_app1/features/auth/data/models/Category_Model.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
Future<List<CategoryModel>> getCategories(); 
  Future<User> register({
  required String name,
  required String email,
  required String password,
  required String passwordConfirmation,
  required List<int> interests,
  String? imagePath,
});
}