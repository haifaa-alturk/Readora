import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ هذا هو الاستيراد الصحيح للـ read
import 'package:library_app1/core/api/api_client.dart';
import 'package:library_app1/features/home/data/datasources/LibraryRemoteDataSource.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_event.dart';
import 'package:library_app1/features/home/presentation/pages/Library_view.dart';

import 'package:library_app1/features/home/presentation/pages/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

// دالة بناء شاشة المكتبة باستخدام الـ ApiClient الجاهز الخاص بكِ
  Widget _buildLibraryPage() {
    // 1. إنشاء نسخة من كلاس الـ ApiClient الخاص بمشروعكِ
    final apiClient = ApiClient();

    // 2. تمرير الـ dio المجهز بالرابط والتوكن إلى الـ DataSource
    return BlocProvider(
      create: (context) => LibraryBloc(
        dataSource: LibraryRemoteDataSourceImpl(dio: apiClient.dio),
      )..add(FetchAllBooks()), // جلب الكتب فوراً
      child: const LibraryPage(),
    );
  }

  List<Widget> get _pages => [
    const HomeScreen(), 
    const Center(child: Text("المفضلة")),
 _buildLibraryPage(),
    const Center(child: Text("حسابي")),
  ];

  @override
  void initState() {
    super.initState();
    // ✅ الآن سيعمل الـ add بدون أخطاء
    context.read<HomeBloc>().add(FetchHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(158, 68, 96, 165),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
         backgroundColor: const Color.fromARGB(122, 131, 182, 223),
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 118, 92, 236),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "My Library"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}