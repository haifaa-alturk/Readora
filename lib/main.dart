import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ================= CORE =================
import 'package:library_app1/core/api/api_client.dart';
import 'package:library_app1/core/network_dev3/api_client.dart';

// ================= AUTH =================
import 'package:library_app1/features/auth/data/datasources/auth_remot_datasource.dart';
import 'package:library_app1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:library_app1/features/auth/domain/usecasees/get_categories_usecase.dart';
import 'package:library_app1/features/auth/domain/usecasees/login.dart';
import 'package:library_app1/features/auth/domain/usecasees/signup.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_bloc.dart';

// ================= HOME =================
import 'package:library_app1/features/home/data/datasources/favorite_remote_data_source.dart';
import 'package:library_app1/features/home/data/datasources/home_remote_datasource.dart';
import 'package:library_app1/features/home/data/repositories/home_repository_impl.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_event.dart';

// ================= SEARCH =================
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';

// ================= BOOK DETAILS =================
import 'package:library_app1/features/book_details/data/datasources/book_details_remote_datasource.dart';
import 'package:library_app1/features/book_details/data/repositories/book_details_repository_impl.dart';
import 'package:library_app1/features/book_details/domain/usecases/get_book_details.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';

// ================= BOOK ACCESS =================
import 'package:library_app1/features/book_details/data/datasources/book_access_remote_datasource.dart';
import 'package:library_app1/features/book_details/data/repositories/book_access_repository_impl.dart';
import 'package:library_app1/features/book_details/domain/usecases/check_book_access.dart';

// ================= BOOK ACTIONS =================
import 'package:library_app1/features/book_details/data/datasources/book_action_remote_datasource.dart';
import 'package:library_app1/features/book_details/data/repositories/book_action_repository_impl.dart';
import 'package:library_app1/features/book_details/domain/usecases/purchase_book.dart';
import 'package:library_app1/features/book_details/domain/usecases/borrow_book.dart';

// ================= QUOTES =================
import 'package:library_app1/features/quotes/data/datasources/quotes_remote_datasource.dart';
import 'package:library_app1/features/quotes/data/repositories/quotes_repository_impl.dart';
import 'package:library_app1/features/quotes/presentation/bloc/quotes_bloc.dart';

// ================= INTERESTS =================
import 'package:library_app1/features/interests/data/datasources/interests_remote_datasource.dart';
import 'package:library_app1/features/interests/data/repositories/interests_repository_impl.dart';
import 'package:library_app1/features/interests/presentation/bloc/interests_bloc.dart';

// ================= SETTINGS =================
import 'package:library_app1/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:library_app1/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

// ================= WALLET =================
import 'package:library_app1/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:library_app1/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:library_app1/features/wallet/presentation/bloc/wallet_bloc.dart';

// ================= POINTS =================
import 'package:library_app1/features/points/data/datasources/points_remote_datasource.dart';
import 'package:library_app1/features/points/data/repositories/points_repository_impl.dart';
import 'package:library_app1/features/points/presentation/bloc/points_bloc.dart';

// ================= WINS =================
import 'package:library_app1/features/wins/data/datasources/wins_remote_datasource.dart';
import 'package:library_app1/features/wins/data/repositories/wins_repository_impl.dart';
import 'package:library_app1/features/wins/presentation/bloc/wins_bloc.dart';

// ================= LIBRARY =================
import 'package:library_app1/features/library/data/datasources/library_remote_datasource.dart';
import 'package:library_app1/features/library/data/repositories/library_repository_impl.dart';
import 'package:library_app1/features/library/presentation/bloc/library_bloc.dart';

// ================= PROFILE =================
import 'package:library_app1/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:library_app1/features/profile/data/repositories/profile_repository.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_event.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_event.dart';

// ================= GROUP CHALLENGE =================
import 'package:library_app1/features/group_challenge/data/datasources/group_challenge_remote_datasource.dart';
import 'package:library_app1/features/group_challenge/data/repositories/group_challenge_repository_impl.dart';
import 'package:library_app1/features/group_challenge/presentation/bloc/group_challenge_bloc.dart';

// ================= INDIVIDUAL CHALLENGE =================
import 'package:library_app1/features/individual_challenge/data/datasources/individual_challenge_remote_datasource.dart';
import 'package:library_app1/features/individual_challenge/data/repositories/individual_challenge_repository_impl.dart';
import 'package:library_app1/features/individual_challenge/domain/repositories/individual_challenge_repository_interface.dart';

// ================= RATING =================
import 'package:library_app1/features/rating/data/datasources/rating_remote_datasource.dart';
import 'package:library_app1/features/rating/data/repositories/rating_repository_impl.dart';
import 'package:library_app1/features/rating/domain/repositories/rating_repository.dart';
import 'package:library_app1/features/rating/domain/usecases/rate_book.dart';
import 'package:library_app1/features/rating/domain/usecases/update_rating.dart';
import 'package:library_app1/features/rating/presentation/bloc/rating_bloc.dart';

// ================= SPLASH =================
import 'package:library_app1/onboarding/splash_screen.dart';

// ================================================================
// FIREBASE BACKGROUND MESSAGE HANDLER
// ================================================================

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('وصل إشعار والتطبيق بالخلفية أو مغلق');
  print('عنوان الإشعار: ${message.notification?.title}');
  print('محتوى الإشعار: ${message.notification?.body}');
}

// ================================================================
// LOCAL NOTIFICATIONS
// ================================================================

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.max,
);

// ================================================================
// MAIN
// ================================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // FIREBASE
  // ============================================================

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ============================================================
  // LOCAL NOTIFICATIONS
  // ============================================================

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // ============================================================
  // NOTIFICATION PERMISSION
  // ============================================================

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(alert: true, badge: true, sound: true);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // ============================================================
  // FCM TOKEN
  // ============================================================

  final String? fcmToken = await FirebaseMessaging.instance.getToken();

  print('========================================');
  print('FCM TOKEN: $fcmToken');
  print('========================================');

  // ============================================================
  // FOREGROUND MESSAGES
  // ============================================================

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    print('وصل إشعار والتطبيق مفتوح: ${notification?.title}');

    print('عنوان الإشعار: ${notification?.title}');
    print('محتوى الإشعار: ${notification?.body}');

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: 'Channel for important Readora notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  // ============================================================
  // API CLIENT
  // ============================================================

  final apiClient = ApiClient();

  // ============================================================
  // AUTH
  // ============================================================

  final remoteDataSource = AuthRemoteDataSource(apiClient.dio);

  final authRepository = AuthRepositoryImpl(remoteDataSource);

  final loginUseCase = LoginUseCase(authRepository);

  final registerUseCase = RegisterUseCase(authRepository);

  final getCategoriesUseCase = GetCategoriesUseCase(authRepository);

  // ============================================================
  // HOME
  // ============================================================

  final homeRemoteDataSource = HomeRemoteDataSourceImpl(dio: apiClient.dio);

  final homeRepository = HomeRepositoryImpl(
    remoteDataSource: homeRemoteDataSource,
  );

  // ============================================================
  // BOOK DETAILS
  // ============================================================

  final bookDetailsRemoteDataSource = BookDetailsRemoteDataSourceImpl(
    dio: apiClient.dio,
  );

  final bookDetailsRepository = BookDetailsRepositoryImpl(
    remoteDataSource: bookDetailsRemoteDataSource,
  );

  final getBookDetails = GetBookDetails(bookDetailsRepository);

  // ============================================================
  // BOOK ACCESS
  // ============================================================

  final bookAccessRemoteDataSource = BookAccessRemoteDataSourceImpl(
    dio: apiClient.dio,
  );

  final bookAccessRepository = BookAccessRepositoryImpl(
    remoteDataSource: bookAccessRemoteDataSource,
  );

  final checkBookAccess = CheckBookAccess(bookAccessRepository);

  // ============================================================
  // BOOK ACTIONS
  // ============================================================

  final bookActionRemoteDataSource = BookActionRemoteDataSourceImpl(
    dio: apiClient.dio,
  );

  final bookActionRepository = BookActionRepositoryImpl(
    remoteDataSource: bookActionRemoteDataSource,
  );

  final purchaseBook = PurchaseBook(bookActionRepository);

  final borrowBook = BorrowBook(bookActionRepository);

  // ============================================================
  // DEV3 API CLIENT
  // ============================================================

  final dev3ApiClient = Dev3ApiClient();

  // ============================================================
  // QUOTES
  // ============================================================

  final quotesRemoteDataSource = QuotesRemoteDataSourceImpl();

  final quotesRepository = QuotesRepositoryImpl(quotesRemoteDataSource);

  // ============================================================
  // INTERESTS
  // ============================================================

  final interestsRemoteDataSource = InterestsRemoteDataSourceImpl(apiClient);

  final interestsRepository = InterestsRepositoryImpl(
    interestsRemoteDataSource,
  );

  // ============================================================
  // WALLET
  // ============================================================

  // مهم جداً:
  // WalletRemoteDataSourceImpl يحتاج ApiClient
  // وليس Dev3ApiClient.

  final walletRemoteDataSource = WalletRemoteDataSourceImpl(apiClient);

  final walletRepository = WalletRepositoryImpl(walletRemoteDataSource);

  // ============================================================
  // POINTS
  // ============================================================

  final pointsRemoteDataSource = PointsRemoteDataSourceImpl(apiClient);

  final pointsRepository = PointsRepositoryImpl(pointsRemoteDataSource);

  // ============================================================
  // WINS
  // ============================================================

  final winsRemoteDataSource = WinsRemoteDataSourceImpl(dev3ApiClient);

  final winsRepository = WinsRepositoryImpl(winsRemoteDataSource);

  // ============================================================
  // SETTINGS
  // ============================================================

  final settingsRemoteDataSource = SettingsRemoteDataSourceImpl(dev3ApiClient);

  final settingsRepository = SettingsRepositoryImpl(settingsRemoteDataSource);

  // ============================================================
  // LIBRARY
  // ============================================================

  final libraryRemoteDataSource = LibraryRemoteDataSourceImpl(apiClient);

  final libraryRepository = LibraryRepositoryImpl(libraryRemoteDataSource);

  // ============================================================
  // PROFILE
  // ============================================================

  final profileRemoteDataSource = ProfileRemoteDataSource(
    dev3ApiClient,
    apiClient,
  );

  final profileRepository = ProfileRepositoryImpl(profileRemoteDataSource);

  // ============================================================
  // GROUP CHALLENGE
  // ============================================================

  final groupChallengeRemoteDataSource = GroupChallengeRemoteDataSourceImpl(
    dev3ApiClient,
  );

  final groupChallengeRepository = GroupChallengeRepositoryImpl(
    groupChallengeRemoteDataSource,
  );

  // ============================================================
  // INDIVIDUAL CHALLENGE
  // ============================================================

  final individualChallengeRemoteDataSource =
      IndividualChallengeRemoteDataSourceImpl(apiClient);

  final individualChallengeRepository = IndividualChallengeRepositoryImpl(
    individualChallengeRemoteDataSource,
  );

  // ============================================================
  // RATING
  // ============================================================

  final ratingRemoteDataSource = RatingRemoteDataSourceImpl(dio: apiClient.dio);

  final ratingRepository = RatingRepositoryImpl(
    remoteDataSource: ratingRemoteDataSource,
  );

  final rateBook = RateBook(ratingRepository);

  final updateRating = UpdateRating(ratingRepository);

  // ============================================================
  // RUN APP
  // ============================================================

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IndividualChallengeRepositoryInterface>.value(
          value: individualChallengeRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteBloc>(
            create: (context) => FavoriteBloc(FavoriteRemoteDataSource()),
          ),

          BlocProvider<SearchBloc>(create: (context) => SearchBloc()),

          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(loginUseCase, registerUseCase, getCategoriesUseCase),
          ),

          BlocProvider<HomeBloc>(
            create: (context) =>
                HomeBloc(repository: homeRepository)..add(FetchHomeData()),
          ),

          BlocProvider<BookDetailsBloc>(
            create: (context) => BookDetailsBloc(
              getBookDetails,
              checkBookAccess,
              purchaseBook,
              borrowBook,
            ),
          ),

          BlocProvider<RatingBloc>(
            create: (context) =>
                RatingBloc(rateBook: rateBook, updateRating: updateRating),
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
            create: (context) =>
                ProfileBloc(repository: profileRepository)
                  ..add(const LoadProfileEvent()),
          ),

          BlocProvider<PurchaseHistoryBloc>(
            create: (context) =>
                PurchaseHistoryBloc(repository: profileRepository)
                  ..add(const LoadPurchaseHistoryEvent()),
          ),

          BlocProvider<GroupChallengeBloc>(
            create: (context) =>
                GroupChallengeBloc(repository: groupChallengeRepository),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

// ================================================================
// MY APP
// ================================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        bool isDarkMode = false;
        String language = 'en';

        if (state is SettingsLoaded) {
          isDarkMode = state.isDarkMode;
          language = state.language;
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Readora App',

          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xffe61b72),
            scaffoldBackgroundColor: const Color(0xfffcfbfa),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),

          builder: (context, child) {
            return Directionality(
              textDirection: language == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },

          home: SplashScreen(),
        );
      },
    );
  }
}
