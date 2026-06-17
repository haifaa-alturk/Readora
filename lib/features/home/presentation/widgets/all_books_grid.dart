import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/presentation/widgets/book_card.dart';

class AllBooksGrid extends StatelessWidget {
  final List<Book> books;
  const AllBooksGrid({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
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
          // استخدمي الـ Card الخاص بك هنا
          return BookCard(book: book); 
        },
      ),
    );
  }
}