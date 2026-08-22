import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_event.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_state.dart';

import 'package:library_app1/features/rating/presentation/bloc/rating_bloc.dart';
import 'package:library_app1/features/rating/presentation/bloc/rating_event.dart';
import 'package:library_app1/features/rating/presentation/bloc/rating_state.dart';

class BookDetailsScreen extends StatefulWidget {
  final int bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  int selectedRating = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookDetailsBloc>().add(LoadBookDetailsEvent(widget.bookId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3E9),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Book Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: MultiBlocListener(
        listeners: [
          // =====================================================
          // RATING LISTENER
          // =====================================================
          BlocListener<RatingBloc, RatingState>(
            listener: (context, state) {
              if (state is RatingSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Rating submitted successfully: ${state.rating}/5',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                setState(() {
                  selectedRating = 0;
                });

                // إعادة تحميل تفاصيل الكتاب حتى يظهر التقييم الجديد
                context.read<BookDetailsBloc>().add(
                  LoadBookDetailsEvent(widget.bookId),
                );
              }

              if (state is RatingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),

          // =====================================================
          // BOOK ACTION LISTENER
          // =====================================================
          BlocListener<BookDetailsBloc, BookDetailsState>(
            listener: (context, state) {
              if (state is BookDetailsActionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (state is BookDetailsLoaded && state.hasAccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You now have access to this book.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],

        child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
          builder: (context, state) {
            // ===================================================
            // INITIAL / LOADING
            // ===================================================

            if (state is BookDetailsInitial || state is BookDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ===================================================
            // ERROR
            // ===================================================

            if (state is BookDetailsError) {
              return _buildError(context, state.message);
            }

            // ===================================================
            // LOADED
            // ===================================================

            if (state is BookDetailsLoaded) {
              return _buildBookDetails(context, state, showLoading: false);
            }

            // ===================================================
            // PURCHASE LOADING
            // ===================================================

            if (state is BookDetailsPurchaseLoading) {
              return _buildBookDetails(context, state, showLoading: true);
            }

            // ===================================================
            // BORROW LOADING
            // ===================================================

            if (state is BookDetailsBorrowLoading) {
              return _buildBookDetails(context, state, showLoading: true);
            }

            // ===================================================
            // ACTION ERROR
            // ===================================================

            if (state is BookDetailsActionError) {
              return _buildBookDetails(context, state, showLoading: false);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ===========================================================
  // ERROR
  // ===========================================================

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),

            const SizedBox(height: 15),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.read<BookDetailsBloc>().add(
                  LoadBookDetailsEvent(widget.bookId),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // BOOK DETAILS
  // ===========================================================

  Widget _buildBookDetails(
    BuildContext context,
    dynamic state, {
    required bool showLoading,
  }) {
    final book = state.book;

    final bool hasAccess = state is BookDetailsLoaded ? state.hasAccess : false;

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // =================================================
                // MR DUCKY
                // =================================================
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6B800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pets, color: Colors.white, size: 28),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Mr.Ducky recommends this book!',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // BOOK COVER
                // =================================================
                Container(
                  height: 260,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: book.coverImage.isNotEmpty
                        ? Image.network(
                            book.coverImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.book, size: 90);
                            },
                          )
                        : const Icon(Icons.book, size: 90),
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // BOOK NAME
                // =================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    book.bookName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // LANGUAGE + PAGES
                // =================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.language, size: 18, color: Colors.grey),

                    const SizedBox(width: 5),

                    Text(
                      book.language.isNotEmpty ? book.language : 'Unknown',
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(width: 20),

                    const Icon(Icons.menu_book, size: 18, color: Colors.grey),

                    const SizedBox(width: 5),

                    Text(
                      '${book.pages} Pages',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // =================================================
                // RATING
                // =================================================
                _buildAverageRating(book.rating),

                const SizedBox(height: 20),

                // =================================================
                // DETAILS CARD
                // =================================================
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==========================================
                      // DESCRIPTION
                      // ==========================================
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        book.description.isNotEmpty
                            ? book.description
                            : 'No description available.',
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),

                      const SizedBox(height: 25),

                      // ==========================================
                      // AUTHORS
                      // ==========================================
                      const Text(
                        'Authors',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildAuthors(book.authors),

                      const SizedBox(height: 25),

                      // ==========================================
                      // CATEGORIES
                      // ==========================================
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildCategories(book.categories),

                      const SizedBox(height: 25),

                      // ==========================================
                      // PRICES
                      // ==========================================
                      _buildPrices(book),

                      const SizedBox(height: 30),

                      // ==========================================
                      // MY RATING
                      // ==========================================
                      const Text(
                        'Rate this book',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildRatingSelector(),

                      const SizedBox(height: 10),

                      if (selectedRating > 0)
                        BlocBuilder<RatingBloc, RatingState>(
                          builder: (context, ratingState) {
                            final bool isLoading = ratingState is RatingLoading;

                            return SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context.read<RatingBloc>().add(
                                          SubmitRatingEvent(
                                            bookId: widget.bookId,
                                            rating: selectedRating,
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE6B800),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Text(
                                        'Submit Rating',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 30),

                      // ==========================================
                      // READ PREVIEW
                      // ==========================================
                      if (!hasAccess)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _showComingSoon(
                                context,
                                'Book preview will be opened here.',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE6B800),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Read Preview',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      const SizedBox(height: 15),

                      // ==========================================
                      // BUY & RENT
                      // ==========================================
                      if (!hasAccess)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: showLoading
                                    ? null
                                    : () {
                                        context.read<BookDetailsBloc>().add(
                                          PurchaseBookEvent(
                                            widget.bookId,
                                            'none',
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'Buy',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: showLoading
                                    ? null
                                    : () {
                                        context.read<BookDetailsBloc>().add(
                                          BorrowBookEvent(
                                            widget.bookId,
                                            'none',
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'Rent',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),

                      // ==========================================
                      // ACCESS MESSAGE
                      // ==========================================
                      if (hasAccess) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'You have access to this book.',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 15),

                      // ==========================================
                      // COMMENTS
                      // ==========================================
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showComingSoon(
                              context,
                              'Comments will be available here.',
                            );
                          },
                          icon: const Icon(Icons.comment),
                          label: const Text('Comments'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),

        // =========================================================
        // ACTION LOADING OVERLAY
        // =========================================================
        if (showLoading)
          Container(
            color: Colors.black.withOpacity(0.25),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  // ===========================================================
  // AVERAGE RATING
  // ===========================================================

  Widget _buildAverageRating(double rating) {
    final double average = rating.clamp(0.0, 5.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(5, (index) {
          final int position = index + 1;

          if (average >= position) {
            return const Icon(Icons.star, color: Colors.amber, size: 25);
          }

          if (average >= position - 0.5) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 25);
          }

          return const Icon(Icons.star_border, color: Colors.amber, size: 25);
        }),

        const SizedBox(width: 8),

        Text(
          average.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  // ===========================================================
  // RATING SELECTOR
  // ===========================================================

  Widget _buildRatingSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        final int rating = index + 1;

        return IconButton(
          onPressed: () {
            setState(() {
              selectedRating = rating;
            });
          },
          icon: Icon(
            rating <= selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 34,
          ),
        );
      }),
    );
  }

  // ===========================================================
  // AUTHORS
  // ===========================================================

  Widget _buildAuthors(List<String> authors) {
    if (authors.isEmpty) {
      return const Text(
        'No authors available',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: authors.map((author) {
        return Chip(
          backgroundColor: const Color(0xFFF4E4A6),
          label: Text(author),
        );
      }).toList(),
    );
  }

  // ===========================================================
  // CATEGORIES
  // ===========================================================

  Widget _buildCategories(List<String> categories) {
    if (categories.isEmpty) {
      return const Text(
        'No categories available',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        return Chip(
          backgroundColor: const Color(0xFFF4E4A6),
          label: Text(category),
        );
      }).toList(),
    );
  }

  // ===========================================================
  // PRICES
  // ===========================================================

  Widget _buildPrices(dynamic book) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Icon(Icons.shopping_bag, color: Colors.green),
                const SizedBox(height: 5),
                const Text(
                  'Buy',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  '${book.sellingPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Icon(Icons.calendar_month, color: Colors.blue),
                const SizedBox(height: 5),
                const Text(
                  'Rent',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  '${book.rentalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // TEMPORARY MESSAGE
  // ===========================================================

  void _showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
