// import 'package:dio/dio.dart';
// import 'package:library_app1/features/auth/data/models/Category_Model.dart';
// import '../models/user_model.dart';

// class AuthRemoteDataSource {
//   final Dio dio;

//   AuthRemoteDataSource(this.dio);

//   Future<List<CategoryModel>> getCategories() async {
//   try {
//     final response = await dio.get("categories"); 
    
//     if (response.statusCode == 200) {
//       dynamic rawData = response.data;
//       List<dynamic> list;

//       // التأكد هل البيانات قادمة كمصفوفة مباشرة أم داخل مفتاح 'data'
//       if (rawData is List) {
//         list = rawData;
//       } else if (rawData is Map && rawData.containsKey('data')) {
//         list = rawData['data'];
//       } else {
//         throw Exception("Unexpected JSON format: $rawData");
//       }

//       return list.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
//     } else {
//       throw Exception("Failed to load categories");
//     }
//   } catch (e) {
//     print("❌ Fetch Categories Error: $e"); // للـ Debug
//     throw Exception("Error fetching categories: $e");
//   }
// }

// Future<UserModel> login(String email, String password) async {
//   try {
//     print("🚀 Sending Login Data: email: $email, password: $password");

//     final response = await dio.post(
//       "login",
//       data: {
//       "email": email.trim().toLowerCase(), 
//     "password": password.trim(),
//       },
//     );
// // طباعة للتأكد من وصول الاهتمامات (categories)
//     print("✅ Login Success: ${response.data}");
//     print("Server Response: ${response.data}"); // سيطبع لكِ في الكونسول ماذا رد السيرفر
//     return UserModel.fromJson(response.data);
//   } on DioException catch (e) {
//     // // إذا كان هناك خطأ (مثل 401 أو 422) اطبغي رسالة السيرفر
//     // print("Server Error Response: ${e.response?.data}");
//     // rethrow;
//     print("❌ Login Error Details: ${e.response?.data}");
//     rethrow;
//   }
// }
// Future<UserModel> register({
//     required String name,
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//     required List<int> interests,
//     String? imagePath,
//   }) async {
//     try {
//       Map<String, dynamic> dataMap = {
//         "name": name,
//         "email": email,
//         "password": password,
//         "password_confirmation": passwordConfirmation,
//       };

//       // تحويل مصفوفة الاهتمامات لشكل يفهمه لارافيل (interests[0], interests[1]...)
//       for (var id in interests) {
//   // نضيفها كمصفوفة
//   if (dataMap.containsKey("interests[]")) {
//     (dataMap["interests[]"] as List).add(id.toString());
//   } else {
//     dataMap["interests[]"] = [id.toString()];
//   }
// }

//       if (imagePath != null) {
//         dataMap["user_image"] = await MultipartFile.fromFile(
//           imagePath,
//           filename: imagePath.split('/').last,
//         );
//       }

//       final response = await dio.post(
//         "register",
//         data: FormData.fromMap(dataMap),
//       );

//       print("✅ Register Success Response: ${response.data}");
//       return UserModel.fromJson(response.data);
      
//     } on DioException catch (e) {
//       // هنا تكمن الفائدة: سيطبع لكِ بالضبط ما هو الحقل المرفوض
//       // مثل: {"message":"The email has already been taken.","errors":{"email":["..."]}}
//       print("❌ Register Error (422/Bad Request):");
//       print("Status Code: ${e.response?.statusCode}");
//       print("Error Details: ${e.response?.data}");
      
//       rethrow; // نمرر الخطأ للـ Repository ومن ثم للـ Bloc ليعرضه للمستخدم
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:library_app1/features/auth/data/models/Category_Model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

 Future<List<CategoryModel>> getCategories() async {
  try {
    final response = await dio.get("categories");

    if (response.statusCode == 200) {
      // التعديل هنا: إذا كانت المصفوفة داخل مصفوفة، نأخذ العنصر الأول
      dynamic rawData = response.data;
      List rawList;

      if (rawData is List && rawData.isNotEmpty && rawData.first is List) {
        rawList = rawData.first; // فك التغليف المزدوج [[]] -> []
      } else if (rawData is List) {
        rawList = rawData;
      } else {
        rawList = rawData['data'] ?? [];
      }

      final List<CategoryModel> categories = [];
      for (var item in rawList) {
        categories.add(CategoryModel.fromJson(Map<String, dynamic>.from(item)));
      }
      
      print("✅ Successfully parsed ${categories.length} categories");
      return categories;

    } else {
      throw Exception("Server Error");
    }
  } catch (e) {
    print("❌ Detailed Error: $e");
    throw Exception("Error fetching categories: $e");
  }
}

  // --- دالة تسجيل الدخول (تبقى كما هي) ---
  Future<UserModel> login(String email, String password) async {
    try {
      print("🚀 Sending Login Data: email: $email, password: $password");
      final response = await dio.post(
        "login",
        data: {
          "email": email.trim().toLowerCase(),
          "password": password.trim(),
        },
      );
      print("✅ Login Success: ${response.data}");
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print("❌ Login Error Details: ${e.response?.data}");
      rethrow;
    }
  }

  // --- دالة التسجيل (تبقى كما هي) ---
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required List<int> interests,
    String? imagePath,
  }) async {
    try {
      Map<String, dynamic> dataMap = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };

      for (var id in interests) {
        if (dataMap.containsKey("interests[]")) {
          (dataMap["interests[]"] as List).add(id.toString());
        } else {
          dataMap["interests[]"] = [id.toString()];
        }
      }

      if (imagePath != null) {
        dataMap["user_image"] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }

      final response = await dio.post(
        "register",
        data: FormData.fromMap(dataMap),
      );

      print("✅ Register Success Response: ${response.data}");
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print("❌ Register Error Details: ${e.response?.data}");
      rethrow;
    }
  }
}