import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/core/theme_dev3/app_theme.dart';

import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_event.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_state.dart';

class RentBookPage extends StatefulWidget {
  final int bookId;
  final dynamic book;
  final int points;
  final double wallet;

  const RentBookPage({
    super.key,
    required this.bookId,
    required this.book,
    required this.points,
    required this.wallet,
  });

  @override
  State<RentBookPage> createState() => _RentBookPageState();
}

class _RentBookPageState extends State<RentBookPage> {
  String selectedPackage = 'none';

  bool get isLoading {
    return context.read<BookDetailsBloc>().state is BookDetailsBorrowLoading;
  }

  // ============================================================
  // DISCOUNT OPTIONS
  // ============================================================

  final List<Map<String, dynamic>> discountOptions = [
    {'package': 'none', 'discount': 0, 'points': 0},
    {'package': '15', 'discount': 10, 'points': 15},
    {'package': '30', 'discount': 20, 'points': 30},
    {'package': '45', 'discount': 30, 'points': 45},
    {'package': '60', 'discount': 40, 'points': 60},
    {'package': '75', 'discount': 50, 'points': 75},
  ];

  // ============================================================
  // PRICE
  // ============================================================

  double get rentalPrice {
    final value = widget.book.rentalPrice;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> get selectedOption {
    return discountOptions.firstWhere(
      (option) => option['package'] == selectedPackage,
    );
  }

  int get selectedPoints {
    return selectedOption['points'] as int;
  }

  int get selectedDiscount {
    return selectedOption['discount'] as int;
  }

  double get finalPrice {
    return rentalPrice * (1 - selectedDiscount / 100);
  }

  bool get hasEnoughPoints {
    return widget.points >= selectedPoints;
  }

  bool get hasEnoughWallet {
    return widget.wallet >= finalPrice;
  }

  bool get canRent {
    return hasEnoughPoints && hasEnoughWallet && !isLoading;
  }

  // ============================================================
  // RENT
  // ============================================================

  void _rentBook() {
    if (!hasEnoughPoints) {
      _showMessage(
        "You don't have enough points for this discount.",
        AppTheme.errorRed,
      );
      return;
    }

    if (!hasEnoughWallet) {
      _showMessage("You don't have enough wallet balance.", AppTheme.errorRed);
      return;
    }

    context.read<BookDetailsBloc>().add(
      BorrowBookEvent(widget.bookId, selectedPackage),
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
      backgroundColor: AppTheme.bookBackground,

      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        title: const Text(
          "Rent Book",
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: BlocListener<BookDetailsBloc, BookDetailsState>(
        listener: (context, state) {
          // ====================================================
          // SUCCESS
          // ====================================================

          if (state is BookDetailsLoaded && state.hasAccess) {
            _showSuccessDialog();
          }

          // ====================================================
          // ERROR
          // ====================================================

          if (state is BookDetailsActionError) {
            _showMessage(state.message, AppTheme.errorRed);
          }
        },

        child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
          builder: (context, state) {
            final loading = state is BookDetailsBorrowLoading;

            return Stack(
              children: [_buildContent(), if (loading) _buildLoadingOverlay()],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookHeader(),

          const SizedBox(height: 20),

          _buildRentalInfo(),

          const SizedBox(height: 20),

          _buildBalanceCards(),

          const SizedBox(height: 25),

          const Text(
            "Choose your discount",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          _buildDiscountOptions(),

          const SizedBox(height: 20),

          _buildPriceCard(),

          const SizedBox(height: 15),

          if (!hasEnoughPoints)
            _buildWarning("You don't have enough points for this discount."),

          if (!hasEnoughPoints) const SizedBox(height: 10),

          if (!hasEnoughWallet)
            _buildWarning("You don't have enough wallet balance."),

          if (!hasEnoughWallet) const SizedBox(height: 10),

          _buildRentButton(),

          const SizedBox(height: 15),

          const Center(
            child: Text(
              "Rental period: 30 days",
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOOK HEADER
  // ============================================================

  Widget _buildBookHeader() {
    final image = widget.book.coverImage?.toString() ?? '';

    final imageUrl = image.startsWith('http')
        ? image
        : "http://10.243.228.50:8000/storage/$image";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppTheme.skyGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 90,
                  height: 125,
                  color: AppTheme.skySoft,
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 45,
                    color: AppTheme.skyDark,
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
                  widget.book.bookName.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),

                const SizedBox(height: 10),

                const Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                      color: AppTheme.skyDark,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "30 days rental",
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RENTAL INFO
  // ============================================================

  Widget _buildRentalInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.skySoft),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppTheme.skyDark),
              SizedBox(width: 10),
              Text(
                "Rental Information",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            "You will have full access to this book for 30 days after completing the rental.",
            style: TextStyle(height: 1.5, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BALANCE CARDS
  // ============================================================

  Widget _buildBalanceCards() {
    return Row(
      children: [
        Expanded(
          child: _balanceCard(
            icon: Icons.stars_rounded,
            title: "Points",
            value: widget.points.toString(),
            color: AppTheme.pinkDark,
            background: AppTheme.pinkLight,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _balanceCard(
            icon: Icons.account_balance_wallet_rounded,
            title: "Wallet",
            value: widget.wallet.toStringAsFixed(2),
            color: AppTheme.skyDark,
            background: AppTheme.skyLight,
          ),
        ),
      ],
    );
  }

  Widget _balanceCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 27),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: color)),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
  // DISCOUNT OPTIONS
  // ============================================================

  Widget _buildDiscountOptions() {
    return Column(
      children: discountOptions.map((option) {
        final package = option['package'] as String;
        final discount = option['discount'] as int;
        final requiredPoints = option['points'] as int;

        final enabled = widget.points >= requiredPoints;
        final selected = selectedPackage == package;

        final optionPrice = rentalPrice * (1 - discount / 100);

        return GestureDetector(
          onTap: enabled
              ? () {
                  setState(() {
                    selectedPackage = package;
                  });
                }
              : null,

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              gradient: selected ? AppTheme.skyGradient : null,

              color: selected
                  ? null
                  : enabled
                  ? AppTheme.cardBackground
                  : AppTheme.borderLight,

              borderRadius: BorderRadius.circular(17),

              border: Border.all(
                color: selected ? AppTheme.skyDark : AppTheme.skyLight,
                width: selected ? 2 : 1,
              ),
            ),

            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected
                      ? AppTheme.skyDark
                      : enabled
                      ? AppTheme.skyDark
                      : AppTheme.textSecondary,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        discount == 0 ? "No Discount" : "$discount% OFF",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selected
                              ? AppTheme.textPrimary
                              : enabled
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        requiredPoints == 0
                            ? "No points required"
                            : "$requiredPoints points",
                        style: TextStyle(
                          fontSize: 12,
                          color: selected
                              ? AppTheme.textSecondary
                              : enabled
                              ? AppTheme.textSecondary
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
                    color: selected
                        ? AppTheme.purpleDark
                        : enabled
                        ? AppTheme.skyDark
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // PRICE CARD
  // ============================================================

  Widget _buildPriceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.purpleGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "Final Rental Price",
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            finalPrice.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          if (selectedDiscount > 0)
            Text(
              "You save ${(rentalPrice - finalPrice).toStringAsFixed(2)}",
              style: const TextStyle(
                color: AppTheme.purpleDark,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // WARNING
  // ============================================================

  Widget _buildWarning(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.pinkLight,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // RENT BUTTON
  // ============================================================

  Widget _buildRentButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: canRent ? AppTheme.skyGradient : null,
        color: canRent ? null : AppTheme.borderLight,
        borderRadius: BorderRadius.circular(17),
      ),
      child: ElevatedButton.icon(
        onPressed: canRent ? _rentBook : null,
        icon: const Icon(Icons.bookmark_add_rounded, color: Colors.white),
        label: const Text(
          "RENT NOW",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.25),
      child: Center(
        child: Card(
          color: AppTheme.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppTheme.skyDark),

                const SizedBox(height: 15),

                const Text(
                  "Renting book...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
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
  // SUCCESS DIALOG
  // ============================================================

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: const BoxDecoration(
                  color: AppTheme.greenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 50,
                  color: AppTheme.green,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Rental Successful! 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "You now have access to this book for 30 days.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.skyDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Continue Reading",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
