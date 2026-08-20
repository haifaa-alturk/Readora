import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/challenge_winner_entity.dart';
import '../../domain/entities/group_challenge_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_state.dart';

const List<Color> _winnerPastelColors = [
  Color(0xffFFD6E8), // pastel pink
  Color(0xffD6EAF8), // pastel blue
  Color(0xffD9F2D9), // pastel green
  Color(0xffFFF3C4), // pastel yellow
  Color(0xffE6D9F2), // pastel purple
  Color(0xffFFE0C2), // pastel peach
];

class GroupChallengeWinnersScreen extends StatelessWidget {
  final int eventId;
  final GroupChallengeEntity endedEvent;

  const GroupChallengeWinnersScreen({
    super.key,
    required this.eventId,
    required this.endedEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text(
          'Challenge Winners',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<GroupChallengeBloc, GroupChallengeState>(
        builder: (context, state) {
          final winners = state.winnersByEventId[eventId];
          if (winners == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (winners.isEmpty) {
            return const Center(
              child: Text(
                'No one completed this competition.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final topThree = winners.where((w) => w.rank != null).toList()
            ..sort((a, b) => (a.rank ?? 0).compareTo(b.rank ?? 0));
          final others = winners.where((w) => w.rank == null).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                '🏁 Challenge Ended 🏁',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                'Congratulations to everyone who completed all required books — each finisher earned ${endedEvent.participantPoints} points.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'Top 3',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...topThree.map(_buildTopThreeCard),
              if (others.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Other Winners',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...others.asMap().entries.map(
                      (entry) => _buildOtherCard(entry.value, entry.key),
                    ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopThreeCard(ChallengeWinnerEntity winner) {
    final rank = winner.rank ?? 1;
    final bgColor = rank == 1
        ? const Color(0xffFCE38A)
        : rank == 2
            ? const Color(0xffE0E0E0)
            : const Color(0xffFFE0C2);
    final iconColor = rank == 1
        ? const Color(0xffb8860b)
        : rank == 2
            ? const Color(0xff9e9e9e)
            : const Color(0xffe67e22);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2d2d2d).withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xff2d2d2d).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildAvatar(winner),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              winner.username,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '+${winner.pointsAwarded} pts',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.emoji_events, size: 24, color: iconColor),
        ],
      ),
    );
  }

  Widget _buildOtherCard(ChallengeWinnerEntity winner, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _winnerPastelColors[index % _winnerPastelColors.length],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2d2d2d).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(winner),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              winner.username,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '+${winner.pointsAwarded} pts',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.emoji_events, size: 22, color: Color(0xfffce38a)),
        ],
      ),
    );
  }

  Widget _buildAvatar(ChallengeWinnerEntity winner) {
    final hasAvatar = winner.avatarUrl != null && winner.avatarUrl!.isNotEmpty;
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xff2d2d2d).withValues(alpha: 0.1),
      backgroundImage: hasAvatar ? NetworkImage(winner.avatarUrl!) : null,
      onBackgroundImageError: hasAvatar ? (_, __) {} : null,
      child: hasAvatar
          ? null
          : Text(
              winner.username.isNotEmpty ? winner.username[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
    );
  }
}