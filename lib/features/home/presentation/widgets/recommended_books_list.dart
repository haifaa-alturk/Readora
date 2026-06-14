// import 'package:flutter/material.dart';
// import 'package:library_app1/features/home/domain/entities/book.dart';
// import 'package:library_app1/features/home/presentation/widgets/book_card.dart';

// class RecommendedBooksList extends StatelessWidget {
//   final List<Book> books;
//   const RecommendedBooksList({required this.books, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 250, // طول الكرت الأفقي
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         itemCount: books.length,
//         itemBuilder: (context, index) {
//           final book = books[index];
//           return BookCard(book: book); // سنعرفها بالأسفل
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/presentation/widgets/book_card.dart';

class RecommendedBooksList extends StatelessWidget {
  final List<Book> books;
  const RecommendedBooksList({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text("اختر المزيد من الاهتمامات لعرض اقتراحات مخصصة", style: TextStyle(color: Color.fromARGB(179, 245, 6, 161)))),
      );
    }

    return SizedBox(
       
      height: 250, 
      child: ListView.builder(
        
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(book: books[index]);
        },
      ),
    );
  }
}