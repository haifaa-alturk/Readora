
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:library_app1/core/api/api_client.dart';
// // import 'package:library_app1/core/api_client.dart'; // تأكدي من المسارات
// import 'package:library_app1/features/auth/data/datasources/auth_remot_datasource.dart';
// import 'package:library_app1/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:library_app1/features/auth/domain/usecasees/get_categories_usecase.dart';
// import 'package:library_app1/features/auth/domain/usecasees/login.dart';
// import 'package:library_app1/features/auth/domain/usecasees/signup.dart';
// import 'package:library_app1/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:library_app1/features/home/data/datasources/home_remote_datasource.dart';
// import 'package:library_app1/features/home/data/repositories/home_repository_impl.dart';
// import 'package:library_app1/features/home/domain/repositories/home_repository.dart';
// import 'package:library_app1/features/home/presentation/bloc/home_bloc.dart';
// import 'package:library_app1/features/home/presentation/bloc/home_event.dart';
// import 'package:library_app1/onboarding/splash_screen.dart';

// void main() {
//   final apiClient = ApiClient();
//   final remoteDataSource = AuthRemoteDataSource(apiClient.dio);
//   final authRepository = AuthRepositoryImpl(remoteDataSource);

//   // يجب إنشاء الكائنات (Objects) هنا
//   final loginUseCase = LoginUseCase(authRepository);
//   final registerUseCase = RegisterUseCase(
//     authRepository,
//   ); // تأكدي من استيراد الملف (import)
//   final getCategoriesUseCase = GetCategoriesUseCase(
//     authRepository,
//   ); // أضيفي هذا السطر

//   // --- إعدادات الـ Home الجديدة ---
//   // 1. إنشاء الـ Data Source الخاص بالهوم
//   final homeRemoteDataSource = HomeRemoteDataSourceImpl(dio: apiClient.dio);
//   // 2. إنشاء الـ Repository الـ Implementation
//   final homeRepository = HomeRepositoryImpl(remoteDataSource: homeRemoteDataSource);
  
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (context) => AuthBloc(
//             loginUseCase,
//             registerUseCase, // مرري الكائن الذي أنشأناه بالأعلى
//             getCategoriesUseCase, // مرريه هنا للـ Bloc
//           ),
//         ),
//       // --- هنا نضيف الـ HomeBloc مع الـ Repository الصحيح والـ Event ---
//       // السطر الصحيح
// BlocProvider<HomeBloc>(
//   // الآن سيعمل هذا السطر بدون أخطاء لأننا نمرر repository واحدة فقط
//   create: (context) => HomeBloc(repository: homeRepository)..add(FetchHomeData()),
// ),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Library App',
//       theme: ThemeData(
//         primarySwatch: Colors.amber,
//         brightness: Brightness.dark, // لأن تصميمك Glassmorphism غامق
//       ),
//       home: SplashScreen(),
//     );
//   }
// }
import 'package:library_app1/features/book_details/data/datasources/book_details_remote_datasource.dart';
import 'package:library_app1/features/book_details/data/repositories/book_details_repository_impl.dart';
import 'package:library_app1/features/book_details/domain/usecases/get_book_details.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/core/api/api_client.dart';
// import 'package:library_app1/core/api_client.dart'; // تأكدي من المسارات
import 'package:library_app1/features/auth/data/datasources/auth_remot_datasource.dart';
import 'package:library_app1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:library_app1/features/auth/domain/usecasees/get_categories_usecase.dart';
import 'package:library_app1/features/auth/domain/usecasees/login.dart';
import 'package:library_app1/features/auth/domain/usecasees/signup.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:library_app1/features/home/data/datasources/home_remote_datasource.dart';
import 'package:library_app1/features/home/data/repositories/home_repository_impl.dart';
import 'package:library_app1/features/home/domain/repositories/home_repository.dart';
import 'package:library_app1/features/home/presentation/bloc/home_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/home_event.dart';
import 'package:library_app1/onboarding/splash_screen.dart';
import 'package:library_app1/features/book_details/domain/usecases/get_book_details.dart';

void main() {
  final apiClient = ApiClient();
  final remoteDataSource = AuthRemoteDataSource(apiClient.dio);
  final authRepository = AuthRepositoryImpl(remoteDataSource);

  // يجب إنشاء الكائنات (Objects) هنا
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(
    authRepository,
  ); // تأكدي من استيراد الملف (import)
  final getCategoriesUseCase = GetCategoriesUseCase(
    authRepository,
  ); // أضيفي هذا السطر

  // --- إعدادات الـ Home الجديدة ---
  // 1. إنشاء الـ Data Source الخاص بالهوم
  final homeRemoteDataSource = HomeRemoteDataSourceImpl(dio: apiClient.dio);
  // 2. إنشاء الـ Repository الـ Implementation
  final homeRepository = HomeRepositoryImpl(
    remoteDataSource: homeRemoteDataSource,
  );
  // Book Details

  final bookDetailsRemoteDataSource = BookDetailsRemoteDataSourceImpl(
    dio: apiClient.dio,
  );

  final bookDetailsRepository = BookDetailsRepositoryImpl(
    remoteDataSource: bookDetailsRemoteDataSource,
  );

  final getBookDetails = GetBookDetails(bookDetailsRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase,
            registerUseCase, // مرري الكائن الذي أنشأناه بالأعلى
            getCategoriesUseCase, // مرريه هنا للـ Bloc
          ),
        ),
        // --- هنا نضيف الـ HomeBloc مع الـ Repository الصحيح والـ Event ---
        // السطر الصحيح
        BlocProvider<HomeBloc>(
          // الآن سيعمل هذا السطر بدون أخطاء لأننا نمرر repository واحدة فقط
          create: (context) =>
              HomeBloc(repository: homeRepository)..add(FetchHomeData()),
        ),
        BlocProvider<BookDetailsBloc>(
          create: (context) => BookDetailsBloc(getBookDetails),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.dark, // لأن تصميمك Glassmorphism غامق
      ),
      home: SplashScreen(),
    );
  }
}
