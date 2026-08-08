import 'package:flutter/material.dart';

import '../../domain/entities/challenge_winner_entity.dart';
import '../../domain/entities/group_challenge_entity.dart';

const List<Color> _winnerPastelColors = [
  Color(0xffFFD6E8), // pastel pink
  Color(0xffD6EAF8), // pastel blue
  Color(0xffD9F2D9), // pastel green
  Color(0xffFFF3C4), // pastel yellow
  Color(0xffE6D9F2), // pastel purple
  Color(0xffFFE0C2), // pastel peach
];

class GroupChallengeWinnersScreen extends StatelessWidget {
  final List<ChallengeWinnerEntity> winners;
  final GroupChallengeEntity endedChallenge;

  const GroupChallengeWinnersScreen({
    super.key,
    required this.winners,
    required this.endedChallenge,
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
                style: TextStyle(
                  color: Color(0xff2d2d2d),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '🏁 Challenge Ended 🏁',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff2d2d2d),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "We have many winners! Congratulations to everyone — you've earned ${endedChallenge.bonusPoints} points.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff2d2d2d).withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Winners',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                ),
                const SizedBox(height: 12),
                ...winners.asMap().entries.map((entry) {
                  final index = entry.key;
                  final winner = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _winnerPastelColors[index % _winnerPastelColors.length],
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff2d2d2d)
                              .withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xff2d2d2d)
                              .withValues(alpha: 0.1),
                          backgroundImage: winner.avatarUrl != null &&
                                  winner.avatarUrl!.isNotEmpty
                              ? NetworkImage(winner.avatarUrl!)
                              : null,
                          onBackgroundImageError: winner.avatarUrl != null &&
                                  winner.avatarUrl!.isNotEmpty
                              ? (_, __) {}
                              : null,
                          child: winner.avatarUrl != null &&
                                  winner.avatarUrl!.isNotEmpty
                              ? null
                              : Text(
                                  winner.username.isNotEmpty
                                      ? winner.username[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff2d2d2d),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            winner.username,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff2d2d2d),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.emoji_events,
                          size: 22,
                          color: Color(0xfffce38a),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
