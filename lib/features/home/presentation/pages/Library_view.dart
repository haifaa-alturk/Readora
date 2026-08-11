// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_bloc.dart';
// import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_state.dart';


// class LibraryPage extends StatelessWidget {
//   const LibraryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 250, 253, 254), 
//       appBar: AppBar(
//         title: const Text('My Library', style: TextStyle(color: Color.fromARGB(255, 162, 131, 234), fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: BlocBuilder<LibraryBloc, LibraryState>(
//         builder: (context, state) {
//           if (state is LibraryLoading) {
//             return const Center(child: CircularProgressIndicator(color: Color(0xff8b5cf6)));
//           } else if (state is LibraryLoaded) {
//             if (state.books.isEmpty) {
//               return const Center(child: Text('لا توجد كتب في المكتبة حالياً'));
//             }
//             return GridView.builder(
//               padding: const EdgeInsets.all(16),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, 
//                 crossAxisSpacing: 14,
//                 mainAxisSpacing: 14,
//                 childAspectRatio: 0.65, 
//               ),
//               itemCount: state.books.length,
//               itemBuilder: (context, index) {
//                 final book = state.books[index];
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                     // غلاف الكتاب
// // غلاف الكتاب المحدث بدمج رابط السيرفر
// Expanded(
//   child: ClipRRect(
//     borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//     child: book.coverImage != null && book.coverImage!.isNotEmpty
//         ? Image.network(
//             // قمنا بدمج رابط السيرفر المحلي مع مسار مجلد الـ storage ومسار الصورة
//             book.coverImage!.startsWith('http') 
//                 ? book.coverImage! 
//                 : 'http://127.0.0.1:8000/storage/${book.coverImage}',
//             width: double.infinity,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) => 
//                 const Center(child: Icon(Icons.book, size: 50, color: Colors.grey)),
//           )
//         : const Center(
//             child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
//           ),
//   ),
// ),
//                       // تفاصيل الكتاب
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               book.bookName,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '${book.sellingPrice} \$',
//                               style: const TextStyle(color: Color(0xff8b5cf6), fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else if (state is LibraryError) {
//             return Center(child: Text('حدث خطأ: ${state.message}'));
//           }
//           return const Center(child: Text('اضغط لتحديث المكتبة'));
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/core/language/app_localizations.dart';
import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_state.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';
import '../widgets/book_card.dart'; // 💡 استيراد ويدجت BookCard الموحدة

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
  final lang = settingsState is SettingsLoaded ? settingsState.language : 'en';
    return Scaffold(
backgroundColor: Theme.of(context).scaffoldBackgroundColor, // خلفية داكنة فخمة متناسقة مع الكروت
      appBar: AppBar(
        title:
        Text(context.tr('all_books', lang),
          style: TextStyle(
            color: Color.fromARGB(255, 187, 161, 250),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            );
          } else if (state is LibraryLoaded) {
            if (state.books.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد كتب في المكتبة حالياً',
                  style: TextStyle(color: Color.fromARGB(179, 243, 121, 252), fontSize: 16),
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 👈 جعلناها 3 أعمدة لعرض الكتب بشكل أصغر وأمرح للعين
                crossAxisSpacing: 10, // المسافة الأفقيّة بين الكروت
                mainAxisSpacing: 12,  // المسافة الرأسيّة بين الكروت
                childAspectRatio: 0.52, // 📐 تناسب الأبعاد الكفيل بإظهار الكرت المصغر كاملاً
              ),
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                // 🚀 استدعاء نفس تصميم الـ BookCard الخاص بالهوم
                return BookCard(book: book);
              },
            );
          } else if (state is LibraryError) {
            return Center(
              child: Text(
                'حدث خطأ: ${state.message}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          return const Center(
            child: Text(
              'اضغط لتحديث المكتبة',
              style: TextStyle(color: Color.fromARGB(153, 241, 102, 248)),
            ),
          );
        },
      ),
    );
  }
}