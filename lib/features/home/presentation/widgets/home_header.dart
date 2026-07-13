// import 'package:flutter/material.dart';

// class HomeHeader extends StatelessWidget {
//   final int points;
//   const HomeHeader({required this.points, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return 
//     // SliverToBoxAdapter(
//        Container(
//         padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 99, 152, 172),
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Icon(Icons.notifications_none, color: Color.fromARGB(255, 231, 230, 227), size: 30),
//                 Row(
//                   children: [
//                     // Text("نقاطك: $points", style: const TextStyle(color: Color.fromARGB(255, 243, 7, 180), fontSize: 16)),
//                     const SizedBox(width: 10),
//                     const CircleAvatar(radius: 20, backgroundColor: Color.fromARGB(255, 168, 94, 188), child: Icon(Icons.person)),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Search Bar
//     //         Container(
//     //           decoration: BoxDecoration(
//     //             color: const Color.fromARGB(255, 180, 208, 219),
//     //             borderRadius: BorderRadius.circular(15),
//     //           ),
//     //           child: const TextField(
//     //             decoration: InputDecoration(
                  
//     //               hintText: "Search...",
//     //                hintStyle: TextStyle(
//     //   color: Color.fromARGB(255, 58, 60, 62), 
//     //   fontSize: 16,
//     // ),
//     //               prefixIcon: Icon(Icons.search),
//     //               border: InputBorder.none,
//     //               contentPadding: EdgeInsets.symmetric(vertical: 15),
//     //             ),
//     //           ),
//     //         ),
    
//           ],
//         ),
//       );
//     // );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';
import 'package:library_app1/features/home/presentation/pages/search_screen.dart';

class HomeHeader extends StatelessWidget {
  final int points;
  const HomeHeader({required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 99, 152, 172),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // الصف العلوي (الإشعارات والبروفايل)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.notifications_none, color: Color.fromARGB(255, 231, 230, 227), size: 30),
              Row(
                children: [
                  Text("نقاطك: $points", style: const TextStyle(color: Color.fromARGB(255, 243, 7, 180), fontSize: 16)),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 20, 
                    backgroundColor: Color.fromARGB(255, 168, 94, 188), 
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // استبدلي جزء الـ GestureDetector في ملف home_header.dart بهذا الكود المصمم كزر احترافي:
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
      color: const Color.fromARGB(167, 160, 224, 243), // لون متناسق مع ثيم التطبيق
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center, // لجعل النص والأيقونة في المنتصف كزر
      children: [
        Icon(Icons.tune, color: Colors.white, size: 22), // أيقونة الفلترة والبحث
        SizedBox(width: 12),
        Text(
          "البحث والفلترة المتقدمة",
          style: TextStyle(
            color: Colors.white, 
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
)
        ],
      ),
    );
  }
}
