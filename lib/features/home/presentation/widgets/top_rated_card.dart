import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';

class TopRatedCard extends StatelessWidget {
  final Book book;
  const TopRatedCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network("http://10.0.2.2:8000/storage/${book.coverImage}", 
            width: 50, fit: BoxFit.cover),
        ),
        title: Text(book.bookName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.authors.join(", ")),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(" ${book.rating}/5"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}