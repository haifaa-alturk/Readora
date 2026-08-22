import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/challenge_winner_entity.dart';
import '../../domain/entities/group_challenge_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_state.dart';

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
            // The endpoint works for completed events, so an empty list
            // genuinely means nobody finished this competition.
            return const Center(
              child: Text(
                'No winners yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

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
                'Congratulations to everyone who completed all required books — each finisher earned ${endedEvent.points} points.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 20),
              ...winners.map(_buildWinnerCard),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWinnerCard(ChallengeWinnerEntity winner) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffFFF3C4),
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
          const Icon(Icons.emoji_events, size: 22, color: Color(0xffb8860b)),
        ],
      ),
    );
  }
}
