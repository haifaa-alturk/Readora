import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/core/widgets/gradient_summary_banner.dart';
import 'package:library_app1/features/points/presentation/bloc/points_bloc.dart';
import 'package:library_app1/features/points/presentation/bloc/points_event.dart';
import 'package:library_app1/features/points/presentation/bloc/points_state.dart';
import 'package:library_app1/features/points/domain/entities/points_history_entry_entity.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PointsBloc>().add(const LoadPointsEvent());
  }

  String _formatNumber(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text(
          'Points',
          style: TextStyle(
            color: Color(0xff2d2d2d),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<PointsBloc, PointsState>(
        listener: (context, state) {
          if (state is PointsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PointsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PointsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Color(0xff2d2d2d)),
              ),
            );
          }
          if (state is PointsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GradientSummaryBanner(
                    label: 'Total Points',
                    value: _formatNumber(state.totalPoints),
                    subtitle: 'Your lifetime points earned',
                  ),
                  const SizedBox(height: 24),
                  _buildHistoryList(state.history),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildHistoryList(List<PointsHistoryEntryEntity> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Points History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff2d2d2d),
              ),
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
        history.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No points history yet',
                    style: TextStyle(color: Color(0xff2d2d2d)),
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = history[index];
                  return _buildHistoryTile(entry);
                },
              ),
      ],
    );
  }

  Widget _buildHistoryTile(PointsHistoryEntryEntity entry) {
    final isPositive = entry.isPositive;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff2d2d2d).withValues(alpha: 0.04),
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
              color: isPositive
                  ? const Color(0xff54a747).withValues(alpha: 0.15)
                  : const Color(0xffe61b72).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPositive ? Icons.add_circle : Icons.remove_circle,
              color: isPositive ? const Color(0xff54a747) : const Color(0xffe61b72),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.source,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(entry.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff2d2d2d),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${entry.pointsAmount} pts',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isPositive ? const Color(0xff54a747) : const Color(0xffe61b72),
            ),
          ),
        ],
      ),
    );
  }
}