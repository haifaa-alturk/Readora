import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_event.dart';
import '../bloc/group_challenge_state.dart';
import 'group_challenge_winners_screen.dart';

class EndedEventsScreen extends StatefulWidget {
  const EndedEventsScreen({super.key});

  @override
  State<EndedEventsScreen> createState() => _EndedEventsScreenState();
}

class _EndedEventsScreenState extends State<EndedEventsScreen> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    context.read<GroupChallengeBloc>().add(const LoadEndedEventsEvent());
  }

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

  void _openWinners(BuildContext context, GroupChallengeEntity event) {
    context.read<GroupChallengeBloc>().add(LoadEventWinnersEvent(eventId: event.id));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<GroupChallengeBloc>(),
          child: GroupChallengeWinnersScreen(
            eventId: event.id,
            endedEvent: event,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text(
          'Ended Competitions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<GroupChallengeBloc, GroupChallengeState>(
        builder: (context, state) {
          if (state.isLoadingEnded && state.endedEvents == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = state.endedEvents ?? const <GroupChallengeEntity>[];
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 64,
                    color: const Color(0xff2d2d2d).withValues(alpha: 0.25),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No competitions have ended yet.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final event = events[index];
              return Material(
                color: const Color(0xfff2f1ef),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _openWinners(context, event),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.emoji_events,
                          color: Color(0xff8CD7F7),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}