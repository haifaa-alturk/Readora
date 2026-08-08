import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/core/widgets/gradient_summary_banner.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_event.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_state.dart';
import 'package:library_app1/features/profile/domain/entities/purchase_history_entity.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseHistoryBloc, PurchaseHistoryState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xfffcfbfa),
          appBar: AppBar(
            backgroundColor: const Color(0xfffcfbfa),
            elevation: 0,
            title: const Text(
              'My Purchases',
              style: TextStyle(
                color: Color(0xff2d2d2d),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(PurchaseHistoryState state) {
    if (state is PurchaseHistoryLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is PurchaseHistoryError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Color(0xff2d2d2d)),
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
                      color: Color(0xff2d2d2d),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No purchases yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff2d2d2d),
                      ),
                    ),
                  ],
                ),
              ),
              ]
            : transactions.map((tx) => _buildTransactionTile(tx)).toList();
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

  Widget _buildTransactionTile(PurchaseHistoryEntity tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xff2d2d2d).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tx.isPurchase
                  ? const Color(0xff54a747).withValues(alpha: 0.15)
                  : const Color(0xffe61b72).withValues(alpha: 0.15),
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
                    color: Color(0xff2d2d2d),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(tx.purchaseDate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff2d2d2d),
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

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}