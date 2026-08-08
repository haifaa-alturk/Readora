
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
import 'package:library_app1/core/network_dev3/api_client.dart';
import 'package:library_app1/features/auth/data/datasources/auth_remot_datasource.dart';
import 'package:library_app1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:library_app1/features/auth/domain/usecasees/get_categories_usecase.dart';
import 'package:library_app1/features/auth/domain/usecasees/login.dart';
import 'package:library_app1/features/auth/domain/usecasees/signup.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:library_app1/features/home/data/datasources/home_remote_datasource.dart';
import 'package:library_app1/features/home/data/repositories/home_repository_impl.dart';
import 'package:library_app1/features/home/domain/repositories/home_repository.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_event.dart';
import 'package:library_app1/features/quotes/data/datasources/quotes_remote_datasource.dart';
import 'package:library_app1/features/quotes/data/repositories/quotes_repository_impl.dart';
import 'package:library_app1/features/quotes/presentation/bloc/quotes_bloc.dart';
import 'package:library_app1/features/interests/data/datasources/interests_remote_datasource.dart';
import 'package:library_app1/features/interests/data/repositories/interests_repository_impl.dart';
import 'package:library_app1/features/interests/domain/repositories/interests_repository_interface.dart';
import 'package:library_app1/features/interests/presentation/bloc/interests_bloc.dart';
import 'package:library_app1/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:library_app1/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:library_app1/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:library_app1/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:library_app1/features/points/data/datasources/points_remote_datasource.dart';
import 'package:library_app1/features/points/data/repositories/points_repository_impl.dart';
import 'package:library_app1/features/points/domain/repositories/points_repository_interface.dart';
import 'package:library_app1/features/points/presentation/bloc/points_bloc.dart';
import 'package:library_app1/features/wins/data/datasources/wins_remote_datasource.dart';
import 'package:library_app1/features/wins/data/repositories/wins_repository_impl.dart';
import 'package:library_app1/features/wins/domain/repositories/wins_repository_interface.dart';
import 'package:library_app1/features/wins/presentation/bloc/wins_bloc.dart';
import 'package:library_app1/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:library_app1/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:library_app1/features/settings/domain/repositories/settings_repository_interface.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/library/data/datasources/library_remote_datasource.dart';
import 'package:library_app1/features/library/data/repositories/library_repository_impl.dart';
import 'package:library_app1/features/library/domain/repositories/library_repository_interface.dart';
import 'package:library_app1/features/library/presentation/bloc/library_bloc.dart';
import 'package:library_app1/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:library_app1/features/profile/data/repositories/profile_repository.dart';
import 'package:library_app1/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_event.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_event.dart';
import 'package:library_app1/features/group_challenge/data/datasources/group_challenge_remote_datasource.dart';
import 'package:library_app1/features/group_challenge/data/repositories/group_challenge_repository_impl.dart';
import 'package:library_app1/features/group_challenge/presentation/bloc/group_challenge_bloc.dart';
import 'package:library_app1/features/individual_challenge/data/datasources/individual_challenge_remote_datasource.dart';
import 'package:library_app1/features/individual_challenge/data/repositories/individual_challenge_repository_impl.dart';
import 'package:library_app1/features/individual_challenge/domain/repositories/individual_challenge_repository_interface.dart';
import 'package:library_app1/onboarding/splash_screen.dart';

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

  // Quotes (dev3) — uses Dev3ApiClient & mock data
  final dev3ApiClient = Dev3ApiClient();
  final quotesRemoteDataSource = QuotesRemoteDataSourceImpl(dev3ApiClient);
  final quotesRepository = QuotesRepositoryImpl(quotesRemoteDataSource);

  // Interests — uses real ApiClient (real categories from GET /categories)
  final interestsRemoteDataSource = InterestsRemoteDataSourceImpl(apiClient);
  final interestsRepository = InterestsRepositoryImpl(interestsRemoteDataSource);

  // Wallet (dev3) — uses same Dev3ApiClient & mock data
  final walletRemoteDataSource = WalletRemoteDataSourceImpl(dev3ApiClient);
  final walletRepository = WalletRepositoryImpl(walletRemoteDataSource);

  // Points (dev3) — uses same Dev3ApiClient & mock data
  final pointsRemoteDataSource = PointsRemoteDataSourceImpl(dev3ApiClient);
  final pointsRepository = PointsRepositoryImpl(pointsRemoteDataSource);

  // Wins (dev3) — uses same Dev3ApiClient & mock data
  final winsRemoteDataSource = WinsRemoteDataSourceImpl(dev3ApiClient);
  final winsRepository = WinsRepositoryImpl(winsRemoteDataSource);

  // Settings (dev3) — uses same Dev3ApiClient & mock data
  final settingsRemoteDataSource = SettingsRemoteDataSourceImpl(dev3ApiClient);
  final settingsRepository = SettingsRepositoryImpl(settingsRemoteDataSource);

  // Personal Library (dev3) — uses same Dev3ApiClient & mock data
  final libraryRemoteDataSource = LibraryRemoteDataSourceImpl(dev3ApiClient);
  final libraryRepository = LibraryRepositoryImpl(libraryRemoteDataSource);

  // Profile — uses real ApiClient for user data, Dev3ApiClient remains for mock purchase history support
  // ProfileRepositoryImpl is shared between ProfileBloc and PurchaseHistoryBloc
  final profileRemoteDataSource = ProfileRemoteDataSource(dev3ApiClient, apiClient);
  final profileRepository = ProfileRepositoryImpl(profileRemoteDataSource);

  // Group Challenge (dev3) — uses same Dev3ApiClient & mock data
  final groupChallengeRemoteDataSource =
      GroupChallengeRemoteDataSourceImpl(dev3ApiClient);
  final groupChallengeRepository =
      GroupChallengeRepositoryImpl(groupChallengeRemoteDataSource);

  // Individual Challenge (dev3) — uses same Dev3ApiClient & mock data
  final individualChallengeRemoteDataSource =
      IndividualChallengeRemoteDataSourceImpl(dev3ApiClient);
  final individualChallengeRepository =
      IndividualChallengeRepositoryImpl(individualChallengeRemoteDataSource);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IndividualChallengeRepositoryInterface>.value(
          value: individualChallengeRepository,
        ),
      ],
      child: MultiBlocProvider(
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
        BlocProvider<QuotesBloc>(
          create: (context) => QuotesBloc(repository: quotesRepository),
        ),
        BlocProvider<InterestsBloc>(
          create: (context) => InterestsBloc(repository: interestsRepository),
        ),
        BlocProvider<WalletBloc>(
          create: (context) => WalletBloc(repository: walletRepository),
        ),
        BlocProvider<PointsBloc>(
          create: (context) => PointsBloc(repository: pointsRepository),
        ),
        BlocProvider<WinsBloc>(
          create: (context) => WinsBloc(repository: winsRepository),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(repository: settingsRepository),
        ),
        BlocProvider<LibraryBloc>(
          create: (context) => LibraryBloc(repository: libraryRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(repository: profileRepository)
            ..add(const LoadProfileEvent()),
        ),
        BlocProvider<PurchaseHistoryBloc>(
          create: (context) => PurchaseHistoryBloc(repository: profileRepository)
            ..add(const LoadPurchaseHistoryEvent()),
        ),
          BlocProvider<GroupChallengeBloc>(
            create: (context) => GroupChallengeBloc(
              repository: groupChallengeRepository,
            ),
          ),
        ],
        child: MyApp(),
      ),
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
