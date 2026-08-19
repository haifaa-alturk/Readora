import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/core/language/app_localizations.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_state.dart';

// 🔴 استيراد صفحة تفاصيل الكتاب
import 'package:library_app1/features/home/presentation/pages/book_details_page.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    // ignore: dead_code
    final lang = settingsState is SettingsLoaded
        ? settingsState.language
        : 'en';
    // 🎨 خيارات ألوان الكروت المتبادلة (زهري وبنفسجي فاتح)
    final List<Color> cardColors = [
      const Color.fromARGB(255, 241, 203, 223), // زهري ناعم
      const Color.fromARGB(255, 215, 195, 247), // بنفسجي فاتح
    ];

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ متكيف تلقائياً
      appBar: AppBar(
        title: Text(
          context.tr('favorites', lang),
          style: TextStyle(
            color: Color.fromARGB(255, 143, 76, 225),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            );
          } else if (state is FavoriteLoaded) {
            if (state.favoriteBooks.isEmpty) {
              return Center(
                child: Text(
                  "You haven't added any books to your favorites yet.",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(255, 255, 70, 255)?.withOpacity(
                            0.5,
                          ) // 🌙 لون رمادي داكن وأنيق للوضع الليلي
                        : const Color.fromARGB(255, 58, 1, 51).withOpacity(
                            0.3,
                          ), // ☀️ اللون البيج الأصلي للوضع العادي
                    fontSize: 16,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = state.favoriteBooks[index];

                // 🔄 التناوب بين اللونين بناءً على الـ index
                final Color backgroundColor =
                    cardColors[index % cardColors.length];

                // تجهيز رابط الصورة
                String imageUrl =
                    (book.coverImage != null && book.coverImage!.isNotEmpty)
                    ? (book.coverImage!.startsWith('http')
                          ? book.coverImage!
                          : "http://127.0.0.1:8000/storage/${book.coverImage}")
                    // : "http://192.168.90.2:8000/storage/${book.coverImage}")
                    : "";

                // تجهيز اسم المؤلف
                String authorText = "مؤلف غير معروف";
                if (book.authorName != null &&
                    book.authorName!.trim().isNotEmpty) {
                  authorText = book.authorName!;
                } else if (book.authors.isNotEmpty) {
                  authorText = book.authors.join(", ");
                }

                // 🔴 تغليف الكارت بـ GestureDetector للانتقال للتفاصيل عند الضغط
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
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // 🖼️ صورة غلاف الكتاب مصغرة وبأطراف منحنية
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 60,
                            height: 75,
                            color: Colors.white24,
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.book,
                                              size: 30,
                                              color: Colors.grey,
                                            ),
                                  )
                                : const Icon(
                                    Icons.book,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // 📝 اسم الكتاب واسم المؤلف
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.bookName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(
                                    0xFF2D1B36,
                                  ), // لون داكن واضح للعنوان
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Text(
                              //   authorText,
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: const TextStyle(
                              //     color: Color(0xFF6B4E71), // لون فرعي مريح
                              //     fontSize: 13,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        // 🔴 زر الحذف من المفضلة (القلب المضيء)
                        GestureDetector(
                          onTap: () {
                            context.read<FavoriteBloc>().add(
                              ToggleFavoriteEvent(
                                token: "",
                                bookId: book.id,
                                isCurrentlyFavorite:
                                    true, // عند الضغط سيقوم بالحذف فكلياً
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is FavoriteError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
