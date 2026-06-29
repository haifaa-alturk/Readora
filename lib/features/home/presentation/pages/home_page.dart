
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:library_app1/features/auth/presentation/bloc/auth_state.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Home_Bloc/home_state.dart';
import 'package:library_app1/features/home/presentation/widgets/all_books_grid.dart';
import 'package:library_app1/features/home/presentation/widgets/home_header.dart';
import 'package:library_app1/features/home/presentation/widgets/home_section.dart';
import 'package:library_app1/features/home/presentation/widgets/recommended_books_list.dart';
import 'package:library_app1/features/home/presentation/widgets/top_rated_books_list.dart';


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 70, 55, 20),
//       body: BlocBuilder<HomeBloc, HomeState>(
//         builder: (context, homeState) {
//           if (homeState is HomeLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } 
          
//           if (homeState is HomeLoaded) {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // تمرير النقاط (استخدمنا 250 كقيمة افتراضية مؤقتاً للتجربة)
//                   const HomeHeader(points: 250),

//                   HomeSection(
//                     title: "كتب مقترحة حسب اهتماماتك",
//                     child: RecommendedBooksList(books: homeState.recommendedBooks),
//                   ),

//                   HomeSection(
//                     title: "الكتب الأكثر مبيعاً وتقييماً",
//                     child: TopRatedBooksList(books: homeState.topRatedBooks),
//                   ),

//                   HomeSection(
//                     title: "جميع الكتب (من الأحدث للأقدم)",
//                     child: AllBooksGrid(books: homeState.newBooks),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (homeState is HomeError) {
//             return Center(child: Text("حدث خطأ: ${homeState.message}"));
//           }

//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 195, 231, 241), // لون خلفيتك الداكنة
    body: BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          // 💡 الهيكل الصحيح لمنع التعليق
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 1. إعادة الهيدر (شريط البحث والترحيب) 👈
      const HomeHeader(points: 250,),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Suggested Books ", style: TextStyle(color: Color.fromARGB(255, 143, 76, 225), fontSize: 20,fontWeight: FontWeight.bold)),
                ),
                RecommendedBooksList(books: state.recommendedBooks),

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(" Top Reated Books", style: TextStyle(color: Color.fromARGB(255, 143, 76, 225), fontSize: 20,fontWeight: FontWeight.bold)),
                ),
                TopRatedBooksList(books: state.topRatedBooks),

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("All Books ", style: TextStyle(color: Color.fromARGB(255, 143, 76, 225), fontSize: 20,fontWeight: FontWeight.bold)),
                ),
                AllBooksGrid(books: state.newBooks), // الـ Grid المعدل لح يشتغل بسلاسة هنا
              ],
            ),
          );
        } else if (state is HomeError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        }
        return const Center(child: Text("اضغط لتحميل البيانات"));
      },
    ),
  );
}
}

 // BlocBuilder<HomeBloc, HomeState>(
      //   builder: (context, state) {
      //     if (state is HomeLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     } 
          
      //     else if (state is HomeLoaded) {
      //       return CustomScrollView(
      //         slivers: [
      //           // 1. Header & Search Bar
      //           HomeHeader(points: 250), // سنصممها الآن

      //           // 2. قسم الاقتراحات (أفقي)
      //           SliverToBoxAdapter(
      //             child: HomeSection(
      //               title: "كتب مقترحة حسب اهتماماتك",
      //               child: RecommendedBooksList(books: state.recommendedBooks),
      //             ),
      //           ),

      //           // 3. قسم الأكثر تقييماً (عمودي)
      //           SliverToBoxAdapter(
      //             child: HomeSection(
      //               title: "الكتب الأكثر مبيعاً وتقييماً",
      //               child: TopRatedBooksList(books: state.topRatedBooks),
      //             ),
      //           ),

      //           // 4. جميع الكتب (Grid)
      //           SliverToBoxAdapter(
      //             child: Padding(
      //               padding: const EdgeInsets.all(16.0),
      //               child: Text("جميع الكتب (من الأحدث للأقدم)", 
      //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //             ),
      //           ),
      //           AllBooksGrid(books: state.newBooks),
      //         ],
      //       );
      //     } else if (state is HomeError) {
      //       return Center(child: Text(state.message));
      //     }
      //     return const SizedBox();
      //   },
      // ),
////////////////////////////////
// class HomeScreen extends StatelessWidget {
//   final List<Map<String, String>> books = [
//     {"title": "The Silent Patient"},
//     {"title": "Atomic Habits"},
//     {"title": "Rich Dad Poor Dad"},
//     {"title": "Think and Grow Rich"},
//     {"title": "Deep Work"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,

//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text("Readora 📚"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.person),
//             onPressed: () {},
//           ),
//         ],
//       ),

//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               // 🔍 Search
//               TextField(
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: "Search books...",
//                   hintStyle: TextStyle(color: Colors.white54),
//                   prefixIcon: Icon(Icons.search, color: Colors.white),
//                   filled: true,
//                   fillColor: Colors.white10,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),

//               SizedBox(height: 20),

//               // ⭐ Featured
//               Text(
//                 "Popular Books 🔥",
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               SizedBox(height: 10),

//               SizedBox(
//                 height: 160,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: books.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       width: 130,
//                       margin: EdgeInsets.only(right: 12),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.deepPurple,
//                             Colors.purpleAccent,
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.menu_book,
//                               size: 40, color: Colors.white),
//                           SizedBox(height: 10),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               books[index]["title"]!,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               SizedBox(height: 20),

//               // 📚 All Books
//               Text(
//                 "All Books 📖",
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               SizedBox(height: 10),

//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: books.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.8,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white10,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Stack(
//                       children: [

//                         // 📘 محتوى الكتاب
//                         Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.book,
//                                   size: 40, color: Colors.white),
//                               SizedBox(height: 10),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                                 child: Text(
//                                   books[index]["title"]!,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         // ⭐ Favorite
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: Icon(
//                             Icons.favorite_border,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),

//       // 🎯 Quiz Button
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.amber,
//         child: Icon(Icons.quiz),
//         onPressed: () {},
//       ),
//     );
//   }
// }
