import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_event.dart';
import '../widgets/group_challenge_countdown.dart';

const Color _boxOneOrange = Color(0xffFFA754);
const Color _boxTwoGreen = Color(0xff7ED399);
const Color _boxThreePurple = Color(0xffC299FC);
const Color _softGray = Color(0xfff2f1ef);

class GroupChallengeActiveScreen extends StatelessWidget {
  final GroupChallengeEntity challenge;

  const GroupChallengeActiveScreen({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
              elevation: 0,
              title: const Text(
                'The Challenge Has Started!',
                style: TextStyle(
                 
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoCard(
                  color: _boxOneOrange,
                  icon: Icons.info_outline,
                  heading: 'About This Challenge',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        challenge.description,
                        style: TextStyle(
                          fontSize: 14,
                          
                        ),
                      ),
                    ],
                  ),
                ),
                _buildInfoCard(
                  color: _boxTwoGreen,
                  icon: Icons.timer,
                  heading: 'Time Remaining',
                  child: Center(
                    child: GroupChallengeCountdown(
                      deadline: challenge.deadline,
                      onFinished: () => context.read<GroupChallengeBloc>().add(const RefreshGroupChallengeEvent()),
                    ),
                  ),
                ),
                _buildInfoCard(
                  color: _boxThreePurple,
                  icon: Icons.emoji_events,
                  heading: 'Why should you join this challenge?',
                  child: Text(
                    'Everyone who successfully completes this challenge will receive ${challenge.bonusPoints} bonus points and a commemorative achievement.\nWhy not become one of the winners?',
                    style: TextStyle(
                      fontSize: 14,
                    
                    ),
                  ),
                ),
                if (challenge.isJoined)
                  _buildProgressCard()
                else ...[
                  _buildJoinButtons(context),
                ],
              ],
            ),
    );
  }

  Widget _buildInfoCard({
    required Color color,
    required IconData icon,
    required String heading,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18,),
              const SizedBox(width: 8),
              Text(
                heading,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                 
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

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _softGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildProgressRow(
            '${challenge.userBooksCompleted}/${challenge.requiredBooks} books completed',
            challenge.userBooksCompleted,
            challenge.requiredBooks,
          ),
          const SizedBox(height: 4),
          Text(
            'A book only counts once you pass its Individual Challenge quiz.',
            style: TextStyle(
              fontSize: 12,
             
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, int current, int total) {
    final progress = total > 0 ? current / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
               
              ),
            ),
            Text(
              '$current/$total',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
               
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xff2d2d2d).withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff6dbf82)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildJoinButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              context.read<GroupChallengeBloc>().add(
                    JoinChallengeEvent(challengeId: challenge.id),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfffce38a),
              foregroundColor: const Color(0xff2d2d2d),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Convince Me! I Want To Join'),
          ),
        ),
      ],
    );
  }
}
