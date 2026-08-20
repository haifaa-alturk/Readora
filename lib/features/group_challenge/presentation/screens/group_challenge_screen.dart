import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../points/presentation/bloc/points_bloc.dart';
import '../../../points/presentation/bloc/points_event.dart';
import '../../../wins/domain/entities/win_entity.dart';
import '../../../wins/presentation/bloc/wins_bloc.dart';
import '../../../wins/presentation/bloc/wins_event.dart';
import '../../domain/entities/group_challenge_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_event.dart';
import '../bloc/group_challenge_state.dart';
import 'current_events_screen.dart';
import 'ended_events_screen.dart';
import 'my_competitions_screen.dart';
import 'upcoming_events_screen.dart';

class GroupChallengeScreen extends StatefulWidget {
  const GroupChallengeScreen({super.key});

  @override
  State<GroupChallengeScreen> createState() => _GroupChallengeScreenState();
}

class _GroupChallengeScreenState extends State<GroupChallengeScreen> {
  final Set<int> _notifiedWinEventIds = {};

  @override
  void initState() {
    super.initState();
    context.read<GroupChallengeBloc>().add(const LoadCurrentEventsEvent());
    context.read<GroupChallengeBloc>().add(const LoadMyEventsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text(
          'Competitions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocListener<GroupChallengeBloc, GroupChallengeState>(
        listener: (context, state) {
          final wonEvents = <GroupChallengeEntity>[
            ...?state.currentEvents,
            ...?state.myEvents,
          ];
          for (final event in wonEvents) {
            if (event.userOutcome == 'won' &&
                !_notifiedWinEventIds.contains(event.id)) {
              _notifiedWinEventIds.add(event.id);
              context.read<WinsBloc>().add(ReceiveNewWinEvent(
                    win: WinEntity(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: event.title,
                      description: 'Completed',
                      iconName: 'emoji_events',
                      dateEarned: DateTime.now(),
                      type: 'group_challenge',
                      challengeId: event.id,
                      challengeType: 'group',
                      reward: '${event.userPointsEarned} bonus points',
                      earnedPoints: event.userPointsEarned ?? 0,
                      completedDate: DateTime.now(),
                      status: 'completed',
                    ),
                  ));
              context
                  .read<PointsBloc>()
                  .add(AddPointsEvent(
                    amount: event.userPointsEarned ?? 0,
                    source: 'Challenge',
                  ));
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Reading Competitions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join live events, climb the ranks, and win bonus points.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _buildNavCard(
                      label: 'Current',
                      color: const Color(0xffFFA754),
                      icon: Icons.local_fire_department,
                      screen: const CurrentEventsScreen(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNavCard(
                      label: 'Ended',
                      color: const Color(0xff7ED399),
                      icon: Icons.flag,
                      screen: const EndedEventsScreen(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildNavCard(
                      label: 'Upcoming',
                      color: const Color(0xffC299FC),
                      icon: Icons.schedule,
                      screen: const UpcomingEventsScreen(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNavCard(
                      label: 'My Competitions',
                      color: const Color(0xff8CD7F7),
                      icon: Icons.emoji_events,
                      screen: const MyCompetitionsScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavCard({
    required String label,
    required Color color,
    required IconData icon,
    required Widget screen,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<GroupChallengeBloc>(),
              child: screen,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}