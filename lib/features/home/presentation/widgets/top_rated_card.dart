// import 'package:flutter/material.dart';
// import 'package:library_app1/features/home/domain/entities/book.dart';

// class TopRatedCard extends StatelessWidget {
//   final Book book;
//   const TopRatedCard({required this.book, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(10),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Image.network("http://10.0.2.2:8000/storage/${book.coverImage}", 
//             width: 50, fit: BoxFit.cover),
//         ),
//         title: Text(book.bookName, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(book.authors.join(", ")),
//             Row(
//               children: [
//                 const Icon(Icons.star, color: Colors.amber, size: 16),
//                 Text(" ${book.rating}/5"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';

class TopRatedCard extends StatelessWidget {
  final Book book;
  const TopRatedCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    // 🛡️ معالجة ذكية للرابط لمنع التعليق
    String imageUrl = book.coverImage != null && book.coverImage!.startsWith('http')
        ? book.coverImage!
        : "http://127.0.0.1:8000/storage/${book.coverImage}";

    return Card(
      color: const Color.fromARGB(255, 131, 166, 195),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl, 
            width: 50, 
            height: 70, // تحديد ارتفاع ثابت يحمي الواجهة من التعليق
            fit: BoxFit.cover,
           
            // حماية في حال فشل تحميل الصورة لا يتوقف التطبيق
            errorBuilder: (context, error, stackTrace) => 
                Container(width: 50, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 20)),
          ),
        ),
        title: Text(book.bookName, style: const TextStyle(color:Color.fromARGB(255, 49, 51, 52),fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
  book.authors.isNotEmpty ? book.authors.join(", ") : "مؤلف غير معروف",
  style: const TextStyle(color: Color.fromARGB(255, 88, 81, 81)),
),
            Row(
              children: [
                const Icon(Icons.star, color: Color.fromARGB(255, 180, 6, 243), size: 16),
                Text(" ${book.rating}/5"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}