import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/core/theme_dev3/app_theme.dart';

import 'package:library_app1/features/book_details/presentation/pages/rent_book_page.dart';
import 'package:library_app1/features/book_details/presentation/pages/book_preview_page.dart';
import 'package:library_app1/features/book_details/presentation/pages/book_reader_page.dart';

import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_event.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_state.dart';

import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_state.dart';

import 'package:library_app1/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_state.dart';

import 'package:library_app1/features/individual_challenge/presentation/individual_challenge_entry.dart';

class BookDetailsPage extends StatefulWidget {
  final int bookId;
  final String title;
  final String author;
  final String image;
  final String description;
  final String? pdfFile;

  const BookDetailsPage({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.image,
    required this.description,
    required this.pdfFile,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  // ============================================================
  // ACCESS
  // ============================================================

  // true سواء كان access بسبب Purchase أو Borrow
  bool _hasBookAccess = false;

  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();

    context.read<BookDetailsBloc>().add(LoadBookDetailsEvent(widget.bookId));
  }

  // ============================================================
  // PREVIEW
  // ============================================================

  void _openPreview(String? pdfFile, String bookTitle) {
    if (pdfFile == null || pdfFile.isEmpty) {
      _showMessage("PDF file is not available", AppTheme.errorRed);
      return;
    }

    final pdfUrl =
        pdfFile.startsWith('http://') || pdfFile.startsWith('https://')
        ? pdfFile
        : "http://10.66.254.50:8000/storage/$pdfFile";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookPreviewPage(
          pdfUrl: pdfUrl,
          bookTitle: bookTitle,
          bookId: widget.bookId,
          hasFullAccess: false,
        ),
      ),
    );
  }

  // ============================================================
  // FULL BOOK
  // ============================================================

  void _openFullBook(String? pdfFile, String bookTitle) {
    if (pdfFile == null || pdfFile.isEmpty) {
      _showMessage("PDF file is not available", AppTheme.errorRed);
      return;
    }

    final pdfUrl =
        pdfFile.startsWith('http://') || pdfFile.startsWith('https://')
        ? pdfFile
        : "http://10.66.254.50:8000/storage/$pdfFile";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookReaderPage(
          bookId: widget.bookId,
          pdfUrl: pdfUrl,
          bookTitle: bookTitle,
        ),
      ),
    );
  }

  // ============================================================
  // PURCHASE
  // ============================================================

  void _purchaseBook(dynamic book) {
    final profileState = context.read<ProfileBloc>().state;

    int points = 0;
    double wallet = 0;

    if (profileState is ProfileLoaded) {
      points = profileState.profile.points;
      wallet = profileState.profile.walletBalance;
    }

    _showPurchaseSheet(book: book, points: points, wallet: wallet);
  }

  // ============================================================
  // BORROW / RENT
  // ============================================================

  void _borrowBook(dynamic book) {
    final profileState = context.read<ProfileBloc>().state;

    int points = 0;
    double wallet = 0;

    if (profileState is ProfileLoaded) {
      points = profileState.profile.points;
      wallet = profileState.profile.walletBalance;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RentBookPage(
          bookId: widget.bookId,
          book: book,
          points: points,
          wallet: wallet,
        ),
      ),
    );
  }

  // ============================================================
  // PURCHASE SHEET
  // ============================================================

  void _showPurchaseSheet({
    required dynamic book,
    required int points,
    required double wallet,
  }) {
    String selectedPackage = 'none';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final price = (book.sellingPrice as num).toDouble();

            final discountOptions = [
              {'package': 'none', 'discount': 0, 'points': 0},
              {'package': '15', 'discount': 10, 'points': 15},
              {'package': '30', 'discount': 20, 'points': 30},
              {'package': '45', 'discount': 30, 'points': 45},
              {'package': '60', 'discount': 40, 'points': 60},
              {'package': '75', 'discount': 50, 'points': 75},
            ];

            final selected = discountOptions.firstWhere(
              (option) => option['package'] == selectedPackage,
            );

            final discount = selected['discount'] as int;
            final requiredPoints = selected['points'] as int;

            final finalPrice = price * (1 - discount / 100);

            final canPay = points >= requiredPoints && wallet >= finalPrice;

            return Container(
              decoration: const BoxDecoration(
                color: AppTheme.purpleLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // HANDLE
                      // ==================================================
                      Center(
                        child: Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppTheme.purpleSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // TITLE
                      // ==================================================
                      const Center(
                        child: Text(
                          "Purchase Book",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.purpleDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // BOOK INFO
                      // ==================================================
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              book.coverImage.startsWith('http')
                                  ? book.coverImage
                                  : "http://10.66.254.50:8000/storage/${book.coverImage}",
                              width: 75,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Container(
                                  width: 75,
                                  height: 100,
                                  color: AppTheme.purpleSoft,
                                  child: const Icon(
                                    Icons.book,
                                    size: 40,
                                    color: AppTheme.purpleDark,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.bookName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Original price: ${price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // BALANCES
                      // ==================================================
                      Row(
                        children: [
                          Expanded(
                            child: _balanceCard(
                              icon: Icons.stars,
                              title: "Points",
                              value: "$points",
                              color: AppTheme.pinkDark,
                              lightColor: AppTheme.pinkLight,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: _balanceCard(
                              icon: Icons.account_balance_wallet,
                              title: "Wallet",
                              value: wallet.toStringAsFixed(2),
                              color: AppTheme.skyDark,
                              lightColor: AppTheme.skyLight,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // DISCOUNT TITLE
                      // ==================================================
                      const Text(
                        "Choose your discount",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.purpleDark,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // DISCOUNT OPTIONS
                      // ==================================================
                      ...discountOptions.map((option) {
                        final package = option['package'] as String;
                        final optionDiscount = option['discount'] as int;
                        final optionPoints = option['points'] as int;

                        final optionPrice = price * (1 - optionDiscount / 100);

                        final enabled = points >= optionPoints;
                        final isSelected = selectedPackage == package;

                        return GestureDetector(
                          onTap: enabled
                              ? () {
                                  setSheetState(() {
                                    selectedPackage = package;
                                  });
                                }
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppTheme.purpleGradient
                                  : null,
                              color: isSelected
                                  ? null
                                  : enabled
                                  ? Colors.white
                                  : AppTheme.borderLight,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.purpleDark
                                    : AppTheme.borderLight,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? Colors.white
                                      : enabled
                                      ? AppTheme.purpleDark
                                      : Colors.grey,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        optionDiscount == 0
                                            ? "No Discount"
                                            : "$optionDiscount% OFF",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : enabled
                                              ? AppTheme.textPrimary
                                              : Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        optionPoints == 0
                                            ? "No points required"
                                            : "$optionPoints points",
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white70
                                              : AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  optionPrice.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : enabled
                                        ? AppTheme.purpleDark
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 15),

                      // ==================================================
                      // FINAL PRICE
                      // ==================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          gradient: AppTheme.pinkGradient,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Final Price",
                              style: TextStyle(
                                color: AppTheme.pinkDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              finalPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.pinkDark,
                              ),
                            ),

                            if (discount > 0)
                              Text(
                                "You save ${(price - finalPrice).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: AppTheme.pinkDark,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // PAYMENT ERROR
                      // ==================================================
                      if (!canPay)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: AppTheme.pinkLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            points < requiredPoints
                                ? "You don't have enough points for this discount."
                                : "You don't have enough wallet balance.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.pinkDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // PURCHASE BUTTON
                      // ==================================================
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppTheme.purpleGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: canPay
                                ? () {
                                    Navigator.pop(sheetContext);

                                    setState(() {
                                      _actionInProgress = true;
                                    });

                                    context.read<BookDetailsBloc>().add(
                                      PurchaseBookEvent(
                                        widget.bookId,
                                        selectedPackage,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "PURCHASE NOW",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // BALANCE CARD
  // ============================================================

  Widget _balanceCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color lightColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: color)),

                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHALLENGE
  // ============================================================

  void _openChallenge(String bookTitle) {
    openIndividualChallengeFlow(
      context,
      bookId: widget.bookId,
      bookTitle: bookTitle,
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pinkLight,

      appBar: AppBar(
        backgroundColor: AppTheme.pinkLight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Book Details",
          style: TextStyle(
            color: AppTheme.pinkDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.pinkDark),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              bool isFav = false;

              if (state is FavoriteLoaded) {
                isFav = state.favoriteBooks.any(
                  (book) => book.id == widget.bookId,
                );
              }

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: AppTheme.pinkDark,
                ),
                onPressed: () {
                  context.read<FavoriteBloc>().add(
                    ToggleFavoriteEvent(
                      token: "",
                      bookId: widget.bookId,
                      isCurrentlyFavorite: isFav,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      body: BlocListener<BookDetailsBloc, BookDetailsState>(
        listener: (context, state) {
          // ======================================================
          // PURCHASE / BORROW SUCCESS
          // ======================================================

          if (state is BookDetailsLoaded) {
            if (_actionInProgress && state.hasAccess) {
              setState(() {
                _hasBookAccess = true;
                _actionInProgress = false;
              });

              _showMessage(
                "You now have access to this book! 🎉",
                Colors.green,
              );
            }
          }

          // ======================================================
          // ACTION ERROR
          // ======================================================

          if (state is BookDetailsActionError) {
            if (_actionInProgress) {
              setState(() {
                _actionInProgress = false;
              });
            }

            _showMessage(state.message, AppTheme.errorRed);
          }
        },

        child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
          builder: (context, state) {
            // ====================================================
            // LOADING
            // ====================================================

            if (state is BookDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.pinkDark),
              );
            }

            // ====================================================
            // ERROR
            // ====================================================

            if (state is BookDetailsError) {
              return Center(
                child: Text(state.message, textAlign: TextAlign.center),
              );
            }

            // ====================================================
            // PURCHASE LOADING
            // ====================================================

            if (state is BookDetailsPurchaseLoading) {
              return Stack(
                children: [
                  _buildBookDetails(state.book, false),
                  _loadingOverlay("Purchasing book..."),
                ],
              );
            }

            // ====================================================
            // BORROW LOADING
            // ====================================================

            if (state is BookDetailsBorrowLoading) {
              return Stack(
                children: [
                  _buildBookDetails(state.book, false),
                  _loadingOverlay("Borrowing book..."),
                ],
              );
            }

            // ====================================================
            // ACTION ERROR
            // ====================================================

            if (state is BookDetailsActionError) {
              return _buildBookDetails(state.book, state.hasAccess);
            }

            // ====================================================
            // LOADED
            // ====================================================

            if (state is BookDetailsLoaded) {
              return _buildBookDetails(state.book, state.hasAccess);
            }

            return const Center(
              child: CircularProgressIndicator(color: AppTheme.pinkDark),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // LOADING OVERLAY
  // ============================================================

  Widget _loadingOverlay(String text) {
    return Container(
      color: Colors.black.withOpacity(0.25),
      child: Center(
        child: Card(
          color: AppTheme.pinkLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppTheme.pinkDark),

                const SizedBox(height: 15),

                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.pinkDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOOK DETAILS
  // ============================================================

  Widget _buildBookDetails(dynamic book, bool hasAccess) {
    // Access = Purchase OR Rent
    final access = hasAccess || _hasBookAccess;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      child: Column(
        children: [
          // ======================================================
          // COVER
          // ======================================================
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.pinkSoft, AppTheme.purpleSoft],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                book.coverImage.startsWith('http')
                    ? book.coverImage
                    : "http://10.66.254.50:8000/storage/${book.coverImage}",
                width: 190,
                height: 270,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 190,
                    height: 270,
                    color: AppTheme.purpleLight,
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 90,
                      color: AppTheme.purpleDark,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 22),

          // ======================================================
          // TITLE
          // ======================================================
          Text(
            book.bookName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.purpleDark,
            ),
          ),

          const SizedBox(height: 8),

          if (book.authors.isNotEmpty)
            Text(
              book.authors.join(" • "),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
              ),
            ),

          const SizedBox(height: 18),

          // ======================================================
          // QUICK INFO
          // ======================================================
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  Icons.star_rounded,
                  "Rating",
                  book.rating.toString(),
                  AppTheme.pinkDark,
                  AppTheme.pinkLight,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _infoCard(
                  Icons.menu_book_rounded,
                  "Pages",
                  "${book.pages}",
                  AppTheme.skyDark,
                  AppTheme.skyLight,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _infoCard(
                  Icons.language_rounded,
                  "Language",
                  book.language,
                  AppTheme.purpleDark,
                  AppTheme.purpleLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ======================================================
          // DESCRIPTION
          // ======================================================
          _sectionCard(
            title: "Description",
            icon: Icons.description_outlined,
            color: AppTheme.pinkDark,
            lightColor: AppTheme.pinkLight,
            child: Text(
              book.description,
              style: const TextStyle(
                height: 1.6,
                fontSize: 15,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ======================================================
          // AUTHORS
          // ======================================================
          _sectionCard(
            title: "Authors",
            icon: Icons.person_outline,
            color: AppTheme.skyDark,
            lightColor: AppTheme.skyLight,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.authors.map<Widget>((author) {
                return _tag(author, AppTheme.skySoft, AppTheme.skyDark);
              }).toList(),
            ),
          ),

          const SizedBox(height: 15),

          // ======================================================
          // CATEGORIES
          // ======================================================
          _sectionCard(
            title: "Categories",
            icon: Icons.category_outlined,
            color: AppTheme.purpleDark,
            lightColor: AppTheme.purpleLight,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.categories.map<Widget>((category) {
                return _tag(category, AppTheme.purpleSoft, AppTheme.purpleDark);
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // ACCESS MESSAGE
          // ======================================================
          if (access)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: AppTheme.skyGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_open_rounded, color: AppTheme.skyDark),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "You have access to this book",
                      style: TextStyle(
                        color: AppTheme.skyDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (access) const SizedBox(height: 15),

          // ======================================================
          // READ
          // ======================================================
          _gradientButton(
            text: access ? "Read Full Book" : "Read Preview • First 5 Pages",
            icon: access ? Icons.menu_book_rounded : Icons.preview_rounded,
            colors: access
                ? const [AppTheme.skyDark, AppTheme.skyMedium]
                : const [AppTheme.pinkMedium, AppTheme.pinkDark],
            onPressed: () {
              if (access) {
                _openFullBook(book.pdfFile, book.bookName);
              } else {
                _openPreview(book.pdfFile, book.bookName);
              }
            },
          ),

          // ======================================================
          // CHALLENGE
          // ======================================================
          if (access) ...[
            const SizedBox(height: 12),

            _gradientButton(
              text: "Individual Challenge",
              icon: Icons.emoji_events_rounded,
              colors: const [AppTheme.purpleMedium, AppTheme.purpleDark],
              onPressed: () {
                _openChallenge(book.bookName);
              },
            ),
          ],

          // ======================================================
          // BUY + RENT
          // ======================================================
          if (!access) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _gradientButton(
                    text: "Buy",
                    icon: Icons.shopping_bag_outlined,
                    colors: const [AppTheme.purpleMedium, AppTheme.purpleDark],
                    onPressed: () {
                      _purchaseBook(book);
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _gradientButton(
                    text: "Rent",
                    icon: Icons.bookmark_add_outlined,
                    colors: const [AppTheme.skyMedium, AppTheme.skyDark],
                    onPressed: () {
                      _borrowBook(book);
                    },
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // ======================================================
          // COMMENTS
          // ======================================================
          OutlinedButton.icon(
            onPressed: () {
              _showMessage(
                "Comments will be available soon",
                AppTheme.purpleDark,
              );
            },
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppTheme.purpleDark,
            ),
            label: const Text(
              "Comments",
              style: TextStyle(
                color: AppTheme.purpleDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppTheme.purpleLight,
              side: const BorderSide(color: AppTheme.purpleSoft),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
    Color color,
    Color lightColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 7),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 25),

          const SizedBox(height: 5),

          Text(title, style: TextStyle(fontSize: 11, color: color)),

          const SizedBox(height: 2),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color lightColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightColor),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // TAG
  // ============================================================

  Widget _tag(String text, Color background, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  // ============================================================
  // GRADIENT BUTTON
  // ============================================================

  Widget _gradientButton({
    required String text,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
