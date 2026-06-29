

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
           
            baseUrl: "http://127.0.0.1:8000/api/",
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
          ),
        ) {


 dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
   
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); 
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
      print("🔑 Sending Request with Token: $token");
    }
    return handler.next(options);
  },
));
  }
}