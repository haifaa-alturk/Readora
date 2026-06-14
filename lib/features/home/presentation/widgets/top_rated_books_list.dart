// import 'package:flutter/material.dart';
// import 'package:library_app1/features/home/domain/entities/book.dart';
// import 'package:library_app1/features/home/presentation/widgets/top_rated_card.dart';

// class TopRatedBooksList extends StatelessWidget {
//   final List<Book> books;
//   const TopRatedBooksList({required this.books, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(), // لأننا نستخدم CustomScrollView
//       itemCount: books.length,
//       itemBuilder: (context, index) {
//         return TopRatedCard(book: books[index]); // سنعرفها بالأسفل
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/presentation/widgets/top_rated_card.dart';

class TopRatedBooksList extends StatelessWidget {
  final List<Book> books;
  const TopRatedBooksList({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Text("لا توجد كتب في هذا القسم حالياً", style: TextStyle(color: Color.fromARGB(179, 171, 7, 241)))),
      );
    }

    return Column(
      
      children: books.map((book) => TopRatedCard(book: book)).toList(),
    );
  }
}