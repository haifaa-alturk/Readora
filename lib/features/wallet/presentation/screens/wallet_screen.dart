import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';

import '../../domain/entities/wallet_transaction_entity.dart';

import 'package:library_app1/core/widgets/gradient_summary_banner.dart';

import 'recharge_wallet_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double? _previousBalance;
  int? _previousPoints;

  @override
  void initState() {
    super.initState();

    context.read<WalletBloc>().add(const LoadWalletEvent());
  }

  Future<void> _openRechargeScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RechargeWalletScreen()),
    );

    if (!mounted) return;

    if (result == true) {
      context.read<WalletBloc>().add(const LoadWalletEvent());
    }
  }

  String _formatPrice(double price) {
    final value = price.toStringAsFixed(0);
    final parts = value.split('');

    final buffer = StringBuffer();

    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) {
        buffer.write(',');
      }

      buffer.write(parts[i]);
    }

    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  void _showBalanceAndPointsChanges(
    BuildContext context,
    double balance,
    int points,
  ) {
    if (_previousBalance == null || _previousPoints == null) {
      _previousBalance = balance;
      _previousPoints = points;
      return;
    }

    final balanceDifference = balance - _previousBalance!;

    final pointsDifference = points - _previousPoints!;

    if (balanceDifference != 0) {
      final isIncrease = balanceDifference > 0;

      final message = isIncrease
          ? 'تمت زيادة رصيدك بمقدار ${_formatPrice(balanceDifference.abs())} SYP ✅'
          : 'تم خصم ${_formatPrice(balanceDifference.abs())} SYP من رصيدك 💳';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isIncrease
              ? const Color(0xff54a747)
              : const Color(0xffe61b72),
        ),
      );
    }

    if (pointsDifference != 0) {
      final isIncrease = pointsDifference > 0;

      final message = isIncrease
          ? 'تمت إضافة ${pointsDifference.abs()} نقطة إلى رصيدك ⭐'
          : 'تم خصم ${pointsDifference.abs()} نقطة من رصيدك ⭐';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isIncrease
              ? const Color(0xff54a747)
              : const Color(0xffe61b72),
        ),
      );
    }

    _previousBalance = balance;
    _previousPoints = points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'My Wallet',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xffe61b72)),
            onPressed: _openRechargeScreen,
          ),
        ],
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is WalletLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              _showBalanceAndPointsChanges(
                context,
                state.wallet.balance,
                state.wallet.points,
              );
            });
          }
        },
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WalletError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Color(0xffe61b72),
                    ),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<WalletBloc>().add(const LoadWalletEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is WalletLoaded) {
            final wallet = state.wallet;
            final transactions = state.transactions;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<WalletBloc>().add(const LoadWalletEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GradientSummaryBanner(
                      label: 'Available Balance',
                      value:
                          '${_formatPrice(wallet.balance)} ${wallet.currency}',
                      subtitle: 'Your current wallet balance',
                      trailing: const Icon(
                        Icons.account_balance_wallet,
                        size: 38,
                        color: Color(0xff2d2d2d),
                      ),
                    ),

                    const SizedBox(height: 16),

                    GradientSummaryBanner(
                      label: 'My Points',
                      value: '${wallet.points} Points',
                      subtitle: 'Your current reward points',
                      trailing: const Icon(
                        Icons.stars,
                        size: 38,
                        color: Color(0xff2d2d2d),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _openRechargeScreen,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text(
                          'Recharge Wallet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffe61b72),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    _buildTransactionList(transactions),
                  ],
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTransactionList(List<WalletTransactionEntity> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(color: Color(0xffe61b72)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: const Column(
              children: [
                Icon(Icons.receipt_long_outlined, size: 40, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'Transaction history is not available yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildTransactionTile(transactions[index]);
            },
          ),
      ],
    );
  }

  Widget _buildTransactionTile(WalletTransactionEntity tx) {
    final isCredit = tx.isCredit;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(127, 148, 144, 144).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(87, 179, 174, 174).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xff54a747).withValues(alpha: 0.15)
                  : const Color(0xffe61b72).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isCredit
                  ? const Color(0xff54a747)
                  : const Color(0xffe61b72),
              size: 22,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.source,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(tx.date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          Text(
            '${isCredit ? '+' : '-'}'
            '${_formatPrice(tx.amount)} SYP',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isCredit
                  ? const Color(0xff54a747)
                  : const Color(0xffe61b72),
            ),
          ),
        ],
      ),
    );
  }
}
