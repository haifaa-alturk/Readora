import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    // تذكري وضع رابط السيرفر قبل الصورة
    String imageUrl = "http://127.0.0.1:8000/storage/${book.coverImage}";

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  Container(color: Colors.grey[300], child: const Icon(Icons.book)),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(book.bookName, maxLines: 1, overflow: TextOverflow.ellipsis, 
            style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(book.authors.join(", "), maxLines: 1, 
            style: const TextStyle(color: Color.fromARGB(255, 21, 16, 16), fontSize: 12)),
        ],
      ),
    );
  }
}