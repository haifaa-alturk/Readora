// import 'package:flutter/material.dart';
// import 'package:library_app1/features/home/domain/entities/book.dart';

// class BookCard extends StatelessWidget {
//   final Book book;
//   const BookCard({required this.book, super.key});

//   @override
//   Widget build(BuildContext context) {
//     // تذكري وضع رابط السيرفر قبل الصورة
//     //String imageUrl = "http://127.0.0.1:8000/storage/${book.coverImage}";
// String imageUrl = book.coverImage?.startsWith('http') == true 
//     ? book.coverImage!
//     : "http://127.0.0.1:8000/storage/${book.coverImage}";

//     return Container(
//     //  color: Colors.white,
//       width: 140,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => 
//                   Container(color: const Color.fromARGB(255, 56, 55, 58), child: const Icon(Icons.book)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(book.bookName, maxLines: 1, overflow: TextOverflow.ellipsis, 
//             style: const TextStyle(color: Color.fromARGB(255, 99, 93, 93),fontWeight: FontWeight.bold)),
//         Text(
//   book.authors.isNotEmpty ? book.authors.join(", ") : "مؤلف غير معروف",

//             style: const TextStyle(color: Color.fromARGB(255, 21, 16, 16), fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import '../pages/book_details_page.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';
//import 'package:library_app1/features/book_details/presentation/bloc/book_details_event.dart';
class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    // رابط صورة الكتاب
    String imageUrl = "http://127.0.0.1:8000/storage/${book.coverImage}";

    return GestureDetector(
      onTap: () {
        // الانتقال لصفحة التفاصيل عند الضغط على الكتاب
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsPage(
              bookId: book.id,
              title: book.bookName,
              author: book.authors.join(", "),
              image: imageUrl,
              description: book.description ?? "لا يوجد وصف",
              pdfFile: book.pdfFile,
            ),
          ),
        );
      },

      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 8),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // صورة الكتاب
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),

                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.book),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 5),

            // اسم الكتاب
            Text(
              book.bookName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            // اسم المؤلف
            Text(
              book.authors.join(", "),
              maxLines: 1,

              style: const TextStyle(
                color: Color.fromARGB(255, 21, 16, 16),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

