import 'package:flutter/material.dart';

import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/presentation/widgets/book_card.dart';

class AllBooksGrid extends StatelessWidget {
  final List<Book> books;

  const AllBooksGrid({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            "لا توجد كتب متاحة حالياً",
            style: TextStyle(
              color: Color.fromARGB(255, 241, 199, 244),
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: books.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,

          // متناسب مع BookCard الجديد
          childAspectRatio: 0.70,
        ),

        itemBuilder: (context, index) {
          final book = books[index];

          return BookCard(book: book);
        },
      ),
    );
  }
}
