// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:library_app1/features/auth/domain/usecasees/login.dart';
// import 'package:library_app1/features/auth/domain/usecasees/signup.dart';
// // import '../../domain/usecases/login.dart';
// import 'auth_event.dart';
// import 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final LoginUseCase loginUseCase;
// final RegisterUseCase registerUseCase; 
// AuthBloc(this.loginUseCase, this.registerUseCase) : super(AuthInitial()) {
  
//   on<RegisterEvent>((event, emit) async {
//     emit(AuthLoading());
//     try {
//       final user = await registerUseCase.call(
//         name: event.name, email: event.email,
//         password: event.password, passwordConfirmation: event.confirmPassword,
//         interests: event.interests, imagePath: event.imagePath,
//       );
//       emit(AuthSuccess(user));
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   });

//     on<LoginEvent>((event, emit) async {
//       emit(AuthLoading());

//       try {
//         final user = await loginUseCase(
//           event.email,
//           event.password,
//         );

//         emit(AuthSuccess(user));
//     } catch (e) {
//   if (e is DioException) {
//     // هذا سيطبع لكِ "The email field is required" أو "Credentials do not match"
//     print("Laravel Validation Error: ${e.response?.data}");
//   }
//   emit(AuthError("Login failed: Check your email or password"));
// }
//     });
  
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/auth/domain/usecasees/get_categories_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 1. إضافة المكتبة
import 'package:library_app1/features/auth/domain/usecasees/login.dart';
import 'package:library_app1/features/auth/domain/usecasees/signup.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
final GetCategoriesUseCase getCategoriesUseCase;
AuthBloc(this.loginUseCase, this.registerUseCase, this.getCategoriesUseCase) : super(AuthInitial()) {
    
    // --- معالجة التسجيل (Register) ---
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await registerUseCase.call(
          name: event.name,
          email: event.email,
          password: event.password,
          passwordConfirmation: event.confirmPassword,
          interests: event.interests,
          imagePath: event.imagePath,
        );
// ✅ الوصول للتوكن مباشرة من كائن المستخدم الذي أعاده الـ Use Case
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); 
        
        // هنا نستخدم user.token (تأكدي أن الموديل الخاص بك يحتوي على حقل token)
        await prefs.setString('auth_token', user.token);
        await prefs.setBool('is_logged_in', true);
        
        // إجبار النظام على التأكد من كتابة البيانات فوراً قبل الانتقال
        await prefs.reload();

        print("✅ New Token Saved Successfully: ${user.token}");
        // // ✅ حفظ التوكن عند نجاح التسجيل
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('auth_token', user.token); // تأكدي أن موديل الـ User فيه حقل token
        // await prefs.setBool('is_logged_in', true);

        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // --- معالجة تسجيل الدخول (Login) ---
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(
          event.email,
          event.password,
        );

        // ✅ حفظ التوكن عند نجاح تسجيل الدخول
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', user.token);
        await prefs.setBool('is_logged_in', true);

        emit(AuthSuccess(user));
      } catch (e) {
        if (e is DioException) {
          print("Laravel Validation Error: ${e.response?.data}");
          final errorMessage = e.response?.data['message'] ?? "Login failed";
          emit(AuthError(errorMessage));
        } else {
          emit(AuthError(e.toString()));
        }
      }
    });
////////////////////
    on<GetCategoriesEvent>((event, emit) async {
    emit(CategoriesLoading()); // الحالة التي تجعلنا نظهر مؤشر تحميل أو نمنع الضغط
    try {
      final categories = await getCategoriesUseCase.call();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  });
}
  }
  
