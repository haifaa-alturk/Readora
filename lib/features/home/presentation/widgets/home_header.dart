
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:library_app1/core/language/app_localizations.dart';
// import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';
// import 'package:library_app1/features/home/presentation/pages/notifications_screen.dart';
// import 'package:library_app1/features/home/presentation/pages/search_screen.dart';
// import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
// import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

// class HomeHeader extends StatelessWidget {
//   final int points;
//   const HomeHeader({required this.points, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final settingsState = context.watch<SettingsBloc>().state;
//   final lang = settingsState is SettingsLoaded ? settingsState.language : 'en';
//     return Container(
//       padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
//       decoration: const BoxDecoration(
//         color: Color.fromARGB(255, 159, 120, 194),
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//       ),
//       child: Column(
//         children: [
//           // الصف العلوي (الإشعارات والبروفايل)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
             
//            IconButton(
//   icon: const Icon(
//     Icons.notifications_none,
//     color: Color.fromARGB(255, 231, 230, 227),
//     size: 30,
//   ),
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const NotificationsScreen(),
//       ),
//     );
//   },
// )
//               // const Icon(Icons.notifications_none, color: Color.fromARGB(255, 231, 230, 227), size: 30),
//               // Row(
//               //   children: [
//               //     // Text("نقاطك: $points", style: const TextStyle(color: Color.fromARGB(255, 39, 8, 31), fontSize: 16)),
//               //     const SizedBox(width: 10),
//               //     const CircleAvatar(
//               //       radius: 20, 
//               //       backgroundColor: Color.fromARGB(255, 168, 94, 188), 
//               //       child: Icon(Icons.person, color: Colors.white),
//               //     ),
//               //   ],
//               // ),
//             ],
//           ),
//           const SizedBox(height: 20),
          
//           // استبدلي جزء الـ GestureDetector في ملف home_header.dart بهذا الكود المصمم كزر احترافي:
// GestureDetector(
//  onTap: () {
//   final searchBloc = BlocProvider.of<SearchBloc>(context);

//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => BlocProvider.value(
//         value: searchBloc,
//         child: const SearchScreen(),
//       ),
//     ),
//   );
// },
//   child: Container(
//     width: double.infinity,
//     height: 55,
//     decoration: BoxDecoration(
//       color: Color(0xffc9b6f5), // لون متناسق مع ثيم التطبيق
//       borderRadius: BorderRadius.circular(15),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.15),
//           blurRadius: 8,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center, // لجعل النص والأيقونة في المنتصف كزر
//       children: [
       

//         Center(
//           child: Text(context.tr('search', lang),
//             style: const TextStyle(
//               color: Colors.white, 
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
          
//         ),
//          const Icon(Icons.search, color: Colors.white, size: 22), // أيقونة الفلترة والبحث
//       ],
//     ),
//   ),
// )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/core/language/app_localizations.dart';
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';
import 'package:library_app1/features/home/presentation/pages/notifications_screen.dart';
import 'package:library_app1/features/home/presentation/pages/search_screen.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';


class HomeHeader extends StatelessWidget {
  final int points;
  const HomeHeader({required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    final lang = settingsState is SettingsLoaded ? settingsState.language : 'en';

    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 159, 120, 194),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // الصف العلوي (الإشعارات والبروفايل)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //  هنا يتم وضع كود الشارة الحمراء (Stack)
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color.fromARGB(255, 231, 230, 227),
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  // النقطة الحمراء للإشعارات
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // زر البحث
          GestureDetector(
            onTap: () {
              final searchBloc = BlocProvider.of<SearchBloc>(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: searchBloc,
                    child: const SearchScreen(),
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xffc9b6f5),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      context.tr('search', lang),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.search, color: Colors.white, size: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}