// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:library_app1/features/auth/data/models/auth_response_model.dart';

// class AuthRepository {

//   final String baseUrl = "http://192.168.26.11:8000/api/login";
//   // "http://192.168.26.11:8000";

//   Future<AuthResponseModel> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/login"),
//       headers: {
//         "Accept": "application/json",
//       },
//       body: {
//         "email": email,
//         "password": password,
//       },
//     );

//     print(response.body); // 🔥 مهم للتأكد

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       return AuthResponseModel.fromJson(data);
//     } else {
//       throw Exception(data['message'] ?? "Login failed");
//     }
//   }
// }

import 'package:library_app1/features/auth/data/datasources/auth_remot_datasource.dart';
import 'package:library_app1/features/auth/data/models/Category_Model.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
// import '../datasources/auth_remote_datasource.dart';



class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> login(String email, String password) async {
    final user = await remote.login(email, password);

    return User(
      token: user.token,
      id: user.id,
      name: user.name,
      email: user.email,
      userImage: user.userImage, // أضيفي هذا هنا أيضاً
      interests: user.interests, // أضيفي هذا هنا أيضاً
    );
  }
 @override
  Future<User> register({
    required String name, 
    required String email, 
    required String password, 
    required String passwordConfirmation, 
    required List<int> interests, 
    String? imagePath
  }) async {
    // التعديل هنا: استخدمي remote وليس remoteDataSource
    final userModel = await remote.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      interests: interests,
      imagePath: imagePath,
    );

    // تحويل UserModel إلى User (Entity)
   return User(
  token: userModel.token,
  id: userModel.id,
  name: userModel.name,
  email: userModel.email,
  userImage: userModel.userImage, // مرري الصورة من الموديل للـ Entity
  interests: userModel.interests, // مرري الاهتمامات
);
  }

  @override
Future<List<CategoryModel>> getCategories() async {
  return await remote.getCategories();
}
}