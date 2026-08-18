import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/presentation/pages/book_details_page.dart';
import 'package:library_app1/features/home/presentation/widgets/top_rated_card.dart';

//  استيراد الـ Bloc وصفحة التفاصيل
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_bloc.dart';

class TopRatedBooksList extends StatelessWidget {
  final List<Book> books;
  const TopRatedBooksList({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "لا توجد كتب في هذا القسم حالياً",
            style: TextStyle(color: Color.fromARGB(179, 171, 7, 241)),
          ),
        ),
      );
    }

    return Column(
      children: books.map((book) {
        // تجهيز اسم المؤلف
        String authorText = "مؤلف غير معروف";
        if (book.authorName != null && book.authorName!.trim().isNotEmpty) {
          authorText = book.authorName!;
        } else if (book.authors.isNotEmpty) {
          authorText = book.authors.join(", ");
        }

        // تغليف الكارت بـ GestureDetector للانتقال للتفاصيل
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<FavoriteBloc>(),
                  child: BookDetailsPage(
                    bookId: book.id,
                    title: book.bookName,
                    author: authorText,
                    image: book.coverImage ?? '',
                    description: book.description ?? '',
                    pdfFile: book.pdfFile,
                  ),
                ),
              ),
            );
          },
          child: TopRatedCard(book: book),
        );
      }).toList(),
    );
  }
}