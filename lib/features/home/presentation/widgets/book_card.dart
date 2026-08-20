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
  @override
  Widget build(BuildContext context) {
    // رابط صورة الكتاب مع الحماية من القيمة الفارغة
    String imageUrl =
        (widget.book.coverImage != null && widget.book.coverImage!.isNotEmpty)
        ? (widget.book.coverImage!.startsWith('http')
              ? widget.book.coverImage!
              : "http://10.66.254.50:8000/storage/${widget.book.coverImage}")
        : "";

    return GestureDetector(
      onTap: () {
        // الانتقال إلى صفحة تفاصيل الكتاب
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<FavoriteBloc>(),
              child: BookDetailsPage(
                bookId: widget.book.id,
                title: widget.book.bookName,
                author: widget.book.authors.isNotEmpty
                    ? widget.book.authors.join(", ")
                    : "",
                image: imageUrl,
                description: widget.book.description ?? "لا يوجد وصف",
                pdfFile: widget.book.pdfFile,
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 100,
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
            // صورة الكتاب مع زر المفضلة
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: const Color.fromARGB(255, 236, 236, 223),
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

                  // زر المفضلة
                  if (widget.showFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, state) {
                          bool isFav = false;

                          if (state is FavoriteLoaded) {
                            isFav = state.favoriteBooks.any(
                              (b) => b.id == widget.book.id,
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

            // تفاصيل الكتاب
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم الكتاب
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

                  // اسم المؤلف
                  Builder(
                    builder: (context) {
                      String authorText = "";

                      if (widget.book.authorName != null &&
                          widget.book.authorName!
                              .toString()
                              .trim()
                              .isNotEmpty) {
                        authorText = widget.book.authorName!;
                      } else if (widget.book.authors.isNotEmpty) {
                        authorText = widget.book.authors.join(", ");
                      }

                      return Text(
                        authorText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 88, 5, 101),
                          fontSize: 8,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // السعر والإيجار
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.book.sellingPrice ?? 0} \$",
                        style: const TextStyle(
                          color: Color(0xFFA78BFA),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      if (widget.book.rentalPrice != null)
                        Text(
                          "إيجار: ${widget.book.rentalPrice}\$",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 204, 172, 212),
                            fontSize: 10,
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
