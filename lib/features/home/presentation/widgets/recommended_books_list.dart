import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/presentation/widgets/book_card.dart';

class RecommendedBooksList extends StatelessWidget {
  final List<Book> books;
  const RecommendedBooksList({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // طول الكرت الأفقي
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(book: book); // سنعرفها بالأسفل
        },
      ),
    );
  }
}