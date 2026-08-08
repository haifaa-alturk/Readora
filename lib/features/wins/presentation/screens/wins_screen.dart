import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/wins_bloc.dart';
import '../bloc/wins_event.dart';
import '../bloc/wins_state.dart';
import '../../domain/entities/win_entity.dart';
import 'package:library_app1/core/widgets/gradient_summary_banner.dart';

class WinsScreen extends StatefulWidget {
  const WinsScreen({super.key});

  @override
  State<WinsScreen> createState() => _WinsScreenState();
}

class _WinsScreenState extends State<WinsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WinsBloc>().add(const LoadWinsEvent());
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
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
                'My Wins',
                style: TextStyle(
                  color: Color(0xff2d2d2d),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: BlocConsumer<WinsBloc, WinsState>(
              listener: (context, state) {
                if (state is WinsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is WinsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is WinsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Color(0xff2d2d2d)),
                    ),
                  );
                }
                if (state is WinsEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 64,
                          color: const Color(0xff2d2d2d).withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No wins yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff2d2d2d),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Complete challenges to earn wins!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff2d2d2d),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is WinsLoaded || state is WinsRefreshing) {
                  final wins = state is WinsLoaded
                      ? state.wins
                      : (state as WinsRefreshing).currentWins;
                  final isRefreshing = state is WinsRefreshing;

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<WinsBloc>().add(const RefreshWinsEvent());
                    },
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        GradientSummaryBanner(
                          label: 'Total Wins',
                          value: '${wins.length}',
                          subtitle: 'Challenges completed & achievements earned',
                        ),
                        const SizedBox(height: 16),
                        ...wins.map((win) => _buildWinCard(win)),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
  }

  Widget _buildWinCard(WinEntity win) {
    final isIndividual = win.challengeType == 'individual';
    final badgeBg = isIndividual
        ? const Color(0xfffce38a).withValues(alpha: 0.3)
        : const Color(0xffd4c5f9).withValues(alpha: 0.3);
    final accentColor = isIndividual ? const Color(0xffb8860b) : const Color(0xff7c5cbf);
    final date = win.completedDate ?? win.dateEarned;
    final formattedDate = date != null ? _formatDate(date) : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2d2d2d).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium,
                  size: 28,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isIndividual
                      ? 'INDIVIDUAL CHALLENGE'
                      : 'GROUP CHALLENGE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            win.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xff2d2d2d),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: const Color(0xff2d2d2d).withValues(alpha: 0.08),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: const Color(0xff2d2d2d).withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xff2d2d2d).withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.stars,
                    size: 16,
                    color: const Color(0xff2d7d2d),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+${win.earnedPoints ?? 0} pts',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2d7d2d),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}