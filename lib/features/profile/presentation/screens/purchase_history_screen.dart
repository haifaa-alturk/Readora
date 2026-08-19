import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/core/widgets/gradient_summary_banner.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_state.dart';
import 'package:library_app1/features/profile/domain/entities/purchase_history_entity.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseHistoryBloc, PurchaseHistoryState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: const Text(
              'My Purchases',
              style: TextStyle(
 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PurchaseHistoryState state) {
    if (state is PurchaseHistoryLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is PurchaseHistoryError) {
      return Center(
        child: Text(
          state.message,
 
        ),
      );
    }
    if (state is PurchaseHistoryLoaded) {
      final transactions = state.transactions;
      final totalSpent = transactions.fold<double>(
        0,
        (sum, tx) => sum + tx.price,
      );
      final children = transactions.isEmpty
          ? <Widget>[
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 64,
    
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No purchases yet',
                      style: TextStyle(
                        fontSize: 16,
   
                      ),
                    ),
                  ],
                ),
              ),
            ]
          : transactions.map((tx) => _buildTransactionTile(context, tx)).toList();
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          GradientSummaryBanner(
            label: 'Total Spent',
            value: '${totalSpent.toStringAsFixed(0)} SYP',
            subtitle: 'Across all your purchases & rentals',
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildTransactionTile(BuildContext context, PurchaseHistoryEntity tx) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color.fromARGB(100, 123, 7, 141).withOpacity(0.5) // 🌙 للوضع الليلي
            : const Color.fromARGB(255, 251, 248, 244).withOpacity(0.3), // ☀️ للوضع العادي
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : const Color(0xff2d2d2d).withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tx.isPurchase
                  ? const Color(0xff54a747).withOpacity(0.15)
                  : const Color(0xffe61b72).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tx.isPurchase ? Icons.shopping_bag : Icons.library_books,
              color: tx.isPurchase ? const Color(0xff54a747) : const Color(0xffe61b72),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.bookTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
  
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tx.purchaseDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${tx.typeLabel} ${tx.price.toStringAsFixed(0)} SYP',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: tx.isPurchase ? const Color(0xff54a747) : const Color(0xffe61b72),
            ),
          ),
        ],
      ),
    );
  }
}