import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';

import '../../data/models/book_model.dart';

class FavoriteRemoteDataSource {
  final String baseUrl = "http://10.243.228.50:8000/api";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token') ?? prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Book>> getFavorites([String? unusedToken]) async {
    final headers = await _getHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/books/favourite'),
      headers: headers,
    );

    print("Favorites Response Status: ${response.statusCode}");
    print("Favorites Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((item) => BookModel.fromJson(item)).toList();
    } else {
      throw Exception('فشل في جلب قائمة المفضلة: ${response.statusCode}');
    }
  }

  Future<void> addToFavorite(int bookId, [String? unusedToken]) async {
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/books/$bookId/favourite'),
      headers: headers,
    );

    print("Add Favorite Status: ${response.statusCode}");
    print("Add Favorite Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('فشل إضافة الكتاب للمفضلة');
    }
  }

  Future<void> removeFromFavorite(int bookId, [String? unusedToken]) async {
    final headers = await _getHeaders();

    final response = await http.delete(
      Uri.parse('$baseUrl/books/$bookId/favourite'),
      headers: headers,
    );

    print("Remove Favorite Status: ${response.statusCode}");
    print("Remove Favorite Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('فشل حذف الكتاب من المفضلة');
    }
  }
}
