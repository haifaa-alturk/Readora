
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:library_app1/core/api/api_client.dart';
// import 'package:library_app1/features/home/data/datasources/LibraryRemoteDataSource.dart';
// import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_bloc.dart';
// import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_event.dart';
// import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_bloc.dart';
// import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_event.dart';

// // ⬇️ الـ Imports الجديدة الخاصة بالـ Search Bloc (تأكدي من مطابقة المجلدات لديكِ)
// import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';

// import 'package:library_app1/features/home/presentation/pages/Library_view.dart';
// import 'package:library_app1/features/home/presentation/pages/home_page.dart';
// import 'package:library_app1/features/profile/presentation/screens/profile_main_screen.dart';
// import 'package:library_app1/features/group_challenge/presentation/screens/group_challenge_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   // دالة بناء شاشة المكتبة باستخدام الـ ApiClient الجاهز الخاص بكِ
//   Widget _buildLibraryPage() {
//     final apiClient = ApiClient();

//     return BlocProvider(
//       create: (context) => LibraryBloc(
//         dataSource: LibraryRemoteDataSourceImpl(dio: apiClient.dio),
//       )..add(FetchAllBooks()),
//       child: const LibraryPage(),
//     );
//   }

//   // دالة بناء شاشة الهوم
//   Widget _buildHomePage() {
//     return const HomeScreen();
//   }

//   List<Widget> get _pages => [
//     _buildHomePage(), // واجهة الهوم (0)
//     const Center(child: Text("المفضلة")), // (1)
//     _buildLibraryPage(), // واجهة المكتبة (2)
//     const ProfileMainScreen(), // (3)
//     const GroupChallengeScreen(), // (4)
//   ];

//   @override
//   void initState() {
//     super.initState();
//     context.read<HomeBloc>().add(FetchHomeData());
//   }

//   @override
//   Widget build(BuildContext context) {

//     // 🛡️ نقوم بحقن الـ SearchBloc هنا فوق الـ Scaffold مباشرة
//     // ليكون متاحاً بشكل أمن ومستقر في الهوم والمكتبة بدون أي تعارض أو أخطاء جانبية

//     return BlocProvider(
//       create: (context) => SearchBloc(),
//       child: Scaffold(
//         backgroundColor: const Color(0xfffcfbfa),
//         body: _pages[_selectedIndex],
//         bottomNavigationBar: _buildFloatingNavBar(),
//       ),
//     );
//   }

//   Widget _buildFloatingNavBar() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xffc9b6f5),
//         borderRadius: BorderRadius.circular(32),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.12),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(index: 0, icon: Icons.home, label: 'Home'),
//           _buildNavItem(index: 1, icon: Icons.favorite, label: 'Favorites'),
//           _buildNavItem(index: 2, icon: Icons.book, label: 'Library'),
//           _buildNavItem(index: 3, icon: Icons.person, label: 'Account'),
//           _buildNavItem(index: 4, icon: Icons.event, label: 'Events'),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required int index,
//     required IconData icon,
//     required String label,
//   }) {
//     final bool isActive = _selectedIndex == index;
//     const Color accent = Color(0xfffce38a);
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () => setState(() => _selectedIndex = index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: isActive ? accent : Colors.transparent,
//               boxShadow: isActive
//                   ? [
//                       BoxShadow(
//                         color: accent.withValues(alpha: 0.6),
//                         blurRadius: 18,
//                         spreadRadius: 5,
//                         offset: const Offset(0, 0),
//                       ),
//                     ]
//                   : null,
//             ),
//             child: Icon(
//               icon,
//               size: 24,
//               color: isActive
//                   ? const Color(0xff2d2d2d)
//                   : Colors.white.withValues(alpha: 0.9),
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
//               color: isActive
//                   ? const Color(0xff2d2d2d).withValues(alpha: 0.8)
//                   : Colors.white.withValues(alpha: 0.85),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/core/api/api_client.dart';
import 'package:library_app1/features/home/data/datasources/LibraryRemoteDataSource.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_event.dart';

import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_event.dart';
import 'package:library_app1/features/home/data/datasources/favorite_remote_data_source.dart';
import 'package:library_app1/features/home/presentation/pages/favorites_page.dart';

import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';

import 'package:library_app1/features/home/presentation/pages/Library_view.dart';
import 'package:library_app1/features/home/presentation/pages/home_page.dart';
import 'package:library_app1/features/profile/presentation/screens/profile_main_screen.dart';
import 'package:library_app1/features/group_challenge/presentation/screens/group_challenge_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // دالة بناء شاشة المكتبة
  Widget _buildLibraryPage() {
    final apiClient = ApiClient();

    return BlocProvider(
      create: (context) => LibraryBloc(
        dataSource: LibraryRemoteDataSourceImpl(dio: apiClient.dio),
      )..add(FetchAllBooks()),
      child: const LibraryPage(),
    );
  }

  // 🔴 دالة بناء شاشة المفضلة (تعود بالصفحة مباشرة لتعتمد على ה-Bloc العام الموحد)
  Widget _buildFavoritesPage() {
    return const FavoritesPage();
  }

  // دالة بناء شاشة الهوم
  Widget _buildHomePage() {
    return const HomeScreen();
  }

  List<Widget> get _pages => [
        _buildHomePage(),      // واجهة الهوم (0)
        _buildFavoritesPage(), // واجهة المفضلة (1)
        _buildLibraryPage(),   // واجهة المكتبة (2)
        const ProfileMainScreen(), // (3)
        const GroupChallengeScreen(), // (4)
      ];

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchBloc()),
        // 🌟 FavoriteBloc الموحد ليعمل في الهوم والمفضلة معاً
        BlocProvider(
          create: (context) => FavoriteBloc(FavoriteRemoteDataSource())
            ..add(FetchFavoritesEvent("")),
        ),
      ],
      child: Scaffold(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _pages[_selectedIndex],
        bottomNavigationBar: _buildFloatingNavBar(),
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffc9b6f5),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(index: 0, icon: Icons.home, label: 'Home'),
          _buildNavItem(index: 1, icon: Icons.favorite, label: 'Favorites'),
          _buildNavItem(index: 2, icon: Icons.book, label: 'Library'),
          _buildNavItem(index: 3, icon: Icons.person, label: 'Account'),
          _buildNavItem(index: 4, icon: Icons.event, label: 'Events'),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isActive = _selectedIndex == index;
    const Color accent = Color(0xfffce38a);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? accent : Colors.transparent,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.6),
                        blurRadius: 18,
                        spreadRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              size: 24,
              color: isActive
                  ? const Color(0xff2d2d2d)
                  : Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? const Color(0xff2d2d2d).withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}