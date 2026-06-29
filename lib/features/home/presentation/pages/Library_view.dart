import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Library_Bloc/library_state.dart';


class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd2e9f3), // نفس الخلفية المريحة للتطبيق
      appBar: AppBar(
        title: const Text('My Library', style: TextStyle(color: Color(0xff8b5cf6), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xff8b5cf6)));
          } else if (state is LibraryLoaded) {
            if (state.books.isEmpty) {
              return const Center(child: Text('لا توجد كتب في المكتبة حالياً'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عمودين
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.65, // متناسق مع أبعاد أغلفة الكتب
              ),
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // غلاف الكتاب
// غلاف الكتاب المحدث بدمج رابط السيرفر
Expanded(
  child: ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    child: book.coverImage != null && book.coverImage!.isNotEmpty
        ? Image.network(
            // قمنا بدمج رابط السيرفر المحلي مع مسار مجلد الـ storage ومسار الصورة
            book.coverImage!.startsWith('http') 
                ? book.coverImage! 
                : 'http://127.0.0.1:8000/storage/${book.coverImage}',
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => 
                const Center(child: Icon(Icons.book, size: 50, color: Colors.grey)),
          )
        : const Center(
            child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          ),
  ),
),
                      // تفاصيل الكتاب
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.bookName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${book.sellingPrice} \$',
                              style: const TextStyle(color: Color(0xff8b5cf6), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is LibraryError) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          }
          return const Center(child: Text('اضغط لتحديث المكتبة'));
        },
      ),
    );
  }
}