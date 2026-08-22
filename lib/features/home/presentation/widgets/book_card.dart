import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_state.dart';
import '../pages/book_details_page.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final bool showFavorite;

  const BookCard({required this.book, super.key, this.showFavorite = true});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  // ============================================================
  // IMAGE URL
  // ============================================================

  String get imageUrl {
    final image = widget.book.coverImage;

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<FavoriteBloc>(),
              child: BookDetailsPage(
                bookId: widget.book.id,
                title: widget.book.bookName,
                author: widget.book.authorsText,
                image: imageUrl,
                description: widget.book.description ?? "لا يوجد وصف",
                pdfFile: widget.book.pdfFile,
              ),
            ),
          ),
        );
      },
      child: Container(
        // ========================================================
        // FIX:
        // كان 100x100 وهذا سبب الـ OVERFLOW
        // ========================================================
        width: 155,
        height: 220,

        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 204, 218),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 214, 4, 237).withOpacity(0.2),
              blurRadius: 9,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // COVER + FAVORITE
            // ======================================================
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color.fromARGB(
                                    255,
                                    242,
                                    182,
                                    247,
                                  ),
                                  child: const Icon(
                                    Icons.book,
                                    size: 40,
                                    color: Colors.white54,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.book,
                                size: 40,
                                color: Colors.white54,
                              ),
                            ),
                    ),
                  ),

                  // ==================================================
                  // FAVORITE BUTTON
                  // ==================================================
                  if (widget.showFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, state) {
                          bool isFav = false;

                          if (state is FavoriteLoaded) {
                            isFav = state.favoriteBooks.any(
                              (book) => book.id == widget.book.id,
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              context.read<FavoriteBloc>().add(
                                ToggleFavoriteEvent(
                                  token: "",
                                  bookId: widget.book.id,
                                  isCurrentlyFavorite: isFav,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.redAccent : Colors.white,
                                size: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // ======================================================
            // BOOK DETAILS
            // ======================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // BOOK NAME
                  // ==================================================
                  Text(
                    widget.book.bookName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 46, 3, 36),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // ==================================================
                  // AUTHOR
                  // ==================================================
                  Text(
                    widget.book.authorsText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 88, 5, 101),
                      fontSize: 8,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ==================================================
                  // PRICES
                  //
                  // FIX:
                  // بدل Row عادي يسبب RIGHT OVERFLOW
                  // استخدمنا Expanded + ellipsis
                  // ==================================================
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.book.sellingPriceValue.toStringAsFixed(2)} \$",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFA78BFA),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      if (widget.book.rentalPrice != null)
                        const SizedBox(width: 4),

                      if (widget.book.rentalPrice != null)
                        Expanded(
                          child: Text(
                            "إيجار: "
                            "${widget.book.rentalPriceValue.toStringAsFixed(2)}\$",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 204, 172, 212),
                              fontSize: 9,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
