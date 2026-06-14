// import 'package:flutter/material.dart';
// import 'package:library_app1/features/home/domain/entities/book.dart';
// import 'package:library_app1/features/home/presentation/widgets/book_card.dart';

// class AllBooksGrid extends StatelessWidget {
//   final List<Book> books;
//   const AllBooksGrid({required this.books, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: GridView.builder(
//         // إعدادات ضرورية لتعمل داخل SingleChildScrollView
//         shrinkWrap: true, 
//         physics: const NeverScrollableScrollPhysics(), 
        
//         itemCount: books.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//           childAspectRatio: 0.7,
//         ),
//         itemBuilder: (context, index) {
//           final book = books[index];
//           // استخدمي الـ Card الخاص بك هنا
//           return BookCard(book: book); 
//         },
        
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/presentation/widgets/book_card.dart';

class AllBooksGrid extends StatelessWidget {
  final List<Book> books;
  const AllBooksGrid({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
    // 🛡️ شرط الحماية: إذا عادت قائمة الكتب فارغة من السيرفر، نعرض رسالة بدلاً من تصميم فارغ قد يسبب تعليقاً
    if (books.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            "لا توجد كتب متاحة حالياً",
            style: TextStyle(
              color: Color.fromARGB(255, 139, 163, 235),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        // إعدادات ضرورية لتعمل داخل SingleChildScrollView
        shrinkWrap: true, 
        physics: const NeverScrollableScrollPhysics(), 
        
        itemCount: books.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(book: book); 
        },
      ),
    );
  }
}