import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_event.dart';
import '../bloc/group_challenge_state.dart';
import 'group_challenge_active_screen.dart';
import 'group_challenge_winners_screen.dart';
import '../../../wins/presentation/bloc/wins_bloc.dart';
import '../../../wins/presentation/bloc/wins_event.dart';
import '../../../wins/domain/entities/win_entity.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../points/presentation/bloc/points_bloc.dart';
import '../../../points/presentation/bloc/points_event.dart';

class GroupChallengeScreen extends StatefulWidget {
  const GroupChallengeScreen({super.key});

  @override
  State<GroupChallengeScreen> createState() => _GroupChallengeScreenState();
}

class _GroupChallengeScreenState extends State<GroupChallengeScreen> {
  bool _winAlreadyRecorded = false;

  @override
  void initState() {
    super.initState();
    context.read<GroupChallengeBloc>().add(const LoadGroupChallengeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupChallengeBloc, GroupChallengeState>(
      listener: (context, state) {
        if (state is GroupChallengeWinnersAvailable && !_winAlreadyRecorded) {
          final profileState = context.read<ProfileBloc>().state;
          int? profileUserId;
          if (profileState is ProfileLoaded) {
            profileUserId = profileState.profile.userId;
          }
          // TODO: replace this mock-user-id matching with a real authenticated
          //       user id comparison once auth is implemented app-wide.
          final isWinner = profileUserId != null &&
              state.winners.any((w) => w.userId == profileUserId);
          if (isWinner) {
            _winAlreadyRecorded = true;
            context.read<WinsBloc>().add(ReceiveNewWinEvent(
              win: WinEntity(
                id: DateTime.now().millisecondsSinceEpoch,
                title: state.endedChallenge.title,
                description: 'Completed',
                iconName: 'emoji_events',
                dateEarned: DateTime.now(),
                type: 'group_challenge',
                challengeId: state.endedChallenge.id,
                challengeType: 'group',
                reward:
                    '${state.endedChallenge.bonusPoints} bonus points',
                earnedPoints: state.endedChallenge.bonusPoints,
                completedDate: DateTime.now(),
                status: 'completed',
              ),
            ));
            // Group Challenge points are admin-decided per challenge (bonusPoints), unlike Individual Challenge's fixed 3 points — always read from the challenge entity, never hardcode.
            context.read<PointsBloc>().add(AddPointsEvent(amount: state.endedChallenge.bonusPoints, source: 'Challenge'));
          }
        }
      },
      builder: (context, state) {
        if (state is GroupChallengeInitial || state is GroupChallengeLoading) {
          return _buildShell(
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is GroupChallengeError) {
          return _buildShell(
            child: Center(
              child: Text(
                state.message,

              ),
            ),
          );
        }
        if (state is GroupChallengeEmpty) {
          return _buildShell(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 64,
                  
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No active challenge right now',
                    style: TextStyle(
                      fontSize: 16,
                 
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Check back soon for a new challenge!',
                    style: TextStyle(
                      fontSize: 13,
                      
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is GroupChallengeActive) {
          return GroupChallengeActiveScreen(challenge: state.challenge);
        }
        if (state is GroupChallengeWinnersAvailable) {
          return GroupChallengeWinnersScreen(
            winners: state.winners,
            endedChallenge: state.endedChallenge,
          );
        }
        return _buildShell(
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildShell({required Widget child}) {
    return Scaffold(
            backgroundColor: const Color(0xfffcfbfa),
            appBar: AppBar(
              backgroundColor: const Color(0xfffcfbfa),
              elevation: 0,
              title: const Text(
                'Challenge',
                style: TextStyle(
                
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: child,
    );
  }
}
