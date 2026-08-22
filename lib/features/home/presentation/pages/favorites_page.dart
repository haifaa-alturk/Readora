import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/core/language/app_localizations.dart';

import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_state.dart';

import 'package:library_app1/features/home/presentation/pages/book_details_page.dart';

import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  // ============================================================
  // IMAGE URL
  // ============================================================

  String _buildImageUrl(String? image) {
    if (image == null || image.trim().isEmpty) {
      return "";
    }

    final value = image.trim();

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    return "http://10.243.228.50:8000/storage/"
        "${value.replaceFirst(RegExp(r'^/'), '')}";
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;

    final lang = settingsState is SettingsLoaded
        ? settingsState.language
        : 'en';

    // ============================================================
    // CARD COLORS
    // ============================================================

    final List<Color> cardColors = [
      const Color.fromARGB(255, 241, 203, 223),
      const Color.fromARGB(255, 215, 195, 247),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        title: Text(
          context.tr('favorites', lang),
          style: const TextStyle(
            color: Color.fromARGB(255, 143, 76, 225),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          // ======================================================
          // LOADING
          // ======================================================

          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            );
          }

          // ======================================================
          // LOADED
          // ======================================================

          if (state is FavoriteLoaded) {
            // ====================================================
            // EMPTY
            // ====================================================

            if (state.favoriteBooks.isEmpty) {
              return Center(
                child: Text(
                  "You haven't added any books "
                  "to your favorites yet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(
                            255,
                            255,
                            70,
                            255,
                          ).withOpacity(0.5)
                        : const Color.fromARGB(255, 58, 1, 51).withOpacity(0.3),
                    fontSize: 16,
                  ),
                ),
              );
            }

            // ====================================================
            // FAVORITES LIST
            // ====================================================

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = state.favoriteBooks[index];

                // ==================================================
                // CARD COLOR
                // ==================================================

                final Color backgroundColor =
                    cardColors[index % cardColors.length];

                // ==================================================
                // IMAGE
                // ==================================================

                final String imageUrl = _buildImageUrl(book.coverImage);

                // ==================================================
                // AUTHOR
                // ==================================================

                final String authorText = book.authorsText;

                // ==================================================
                // CARD
                // ==================================================

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
                            image: imageUrl,
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
                        // ==========================================
                        // COVER
                        // ==========================================
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
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.book,
                                        size: 30,
                                        color: Colors.grey,
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.book,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // ==========================================
                        // BOOK INFO
                        // ==========================================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.bookName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF2D1B36),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 6),

                              if (authorText.isNotEmpty)
                                Text(
                                  authorText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF6B4E71),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // ==========================================
                        // REMOVE FAVORITE
                        // ==========================================
                        GestureDetector(
                          onTap: () {
                            context.read<FavoriteBloc>().add(
                              ToggleFavoriteEvent(
                                token: "",
                                bookId: book.id,
                                isCurrentlyFavorite: true,
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
          }

          // ======================================================
          // ERROR
          // ======================================================

          if (state is FavoriteError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
