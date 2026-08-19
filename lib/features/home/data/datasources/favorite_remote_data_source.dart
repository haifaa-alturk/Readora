import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // المكتبة التي تخزنين بها التوكين عند الـ Login
import 'package:library_app1/features/home/domain/entities/book.dart';
import '../../data/models/book_model.dart';

class FavoriteRemoteDataSource {
  final String baseUrl = "http://127.0.0.1:8000/api";
  //final String baseUrl = "http://192.168.90.2:8000/api";
  //  دالة جلب التوكين المحفوظ تلقائياً
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // تأكدي من الاسم الذي حفظتي به التوكين عند تسجيل الدخول (مثلاً: 'token' أو 'auth_token' أو 'ACCESS_TOKEN')
    return prefs.getString('token') ?? prefs.getString('auth_token');
  }

  //  تجهيز الـ Headers مع التوكين
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // جلب قائمة المفضلة
  Future<List<Book>> getFavorites([String? unusedToken]) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/books/favourite'),
      headers: headers,
    );
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => BookModel.fromJson(item)).toList();
    } else {
      throw Exception('فشل في جلب قائمة المفضلة: ${response.statusCode}');
    }
  }

  //  إضافة كتاب للمفضلة
  Future<void> addToFavorite(int bookId, [String? unusedToken]) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/books/$bookId/favourite'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('فشل إضافة الكتاب للمفضلة');
    }
  }

  //  حذف كتاب من المفضلة
  Future<void> removeFromFavorite(int bookId, [String? unusedToken]) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/books/$bookId/favourite'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('فشل حذف الكتاب من المفضلة');
    }
  }
}
