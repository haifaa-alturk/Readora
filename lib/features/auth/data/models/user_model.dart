
// import 'package:library_app1/features/auth/data/models/Category_Model.dart';

// class UserModel {
//   final String token;
//   final int id;
//   final String name;
//   final String email;
//   final String? userImage;
//  final List<CategoryModel>? interests; // بدل List<dynamic>
//   // final List<dynamic>? interests;

//   UserModel({
//     required this.token,
//     required this.id,
//     required this.name,
//     required this.email,
//     this.userImage,
//     this.interests,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     // نصل لبيانات المستخدم من مفتاح 'user'
//     final userData = json['user'];

//     return UserModel(
//       // إذا كان التوكن يأتي في المستوى الأول من الـ JSON
//       token: json['token'] ?? '', 
//       id: userData['id'],
//       name: userData['name'],
//       email: userData['email'],
//       // هنا الأسماء مطابقة تماماً للرد الذي أرسلتِه
//       userImage: userData['user_image'], 
//       // interests: userData['categories'], 

//       interests: (userData['categories'] as List?)
//     ?.map((i) => CategoryModel.fromJson(i))
//     .toList(),
//     );
//   }
// }

import 'package:library_app1/features/auth/data/models/Category_Model.dart';

class UserModel {
  final String token;
  final int id;
  final String name;
  final String email;
  final String? userImage;
  final List<CategoryModel>? interests;

  UserModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    this.userImage,
    this.interests,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
   
    final userData = json['user'];

    return UserModel(
    
      token: json['acceses token'] ?? json['token'] ?? '', 
      
      id: userData['id'] ?? 0,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      userImage: userData['user_image'], 
      
    
      interests: userData['categories'] != null 
          ? (userData['categories'] as List)
              .map((i) => CategoryModel.fromJson(i))
              .toList()
          : [],
    );
  }
}