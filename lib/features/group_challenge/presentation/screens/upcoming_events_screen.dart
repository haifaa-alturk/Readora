import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_event.dart';
import '../bloc/group_challenge_state.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    context.read<GroupChallengeBloc>().add(const LoadUpcomingEventsEvent());
  }

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text(
          'Upcoming Competitions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<GroupChallengeBloc, GroupChallengeState>(
        builder: (context, state) {
          if (state.isLoadingUpcoming && state.upcomingEvents == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final events =
              state.upcomingEvents ?? const <GroupChallengeEntity>[];
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 64,
                    color: const Color(0xff2d2d2d).withValues(alpha: 0.25),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No upcoming competitions yet — check back soon!',
                    textAlign: TextAlign.center,
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
            itemBuilder: (context, index) =>
                _buildEventCard(context, events[index]),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, GroupChallengeEntity event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffD4C5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            event.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.event, size: 16),
              const SizedBox(width: 6),
              Text(
                _formatDate(event.startDate),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.menu_book, size: 16),
              const SizedBox(width: 6),
              Text(
                '${event.requiredBooks.length} books',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildPointsChip(
                icon: Icons.emoji_events,
                iconColor: const Color(0xffb8860b),
                points: event.firstPlacePoints,
              ),
              const SizedBox(width: 8),
              _buildPointsChip(
                icon: Icons.emoji_events,
                iconColor: const Color(0xff9e9e9e),
                points: event.secondPlacePoints,
              ),
              const SizedBox(width: 8),
              _buildPointsChip(
                icon: Icons.emoji_events,
                iconColor: const Color(0xffe67e22),
                points: event.thirdPlacePoints,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: event.isRegistered
                ? _buildRegisteredPill()
                : _buildRegisterButton(context, event),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsChip({
    required IconData icon,
    required Color iconColor,
    required int points,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xff2d2d2d).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 4),
          Text(
            '$points pts',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisteredPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xff2d2d2d).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'Registered ✓',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xff2d2d2d),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, GroupChallengeEntity event) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          context.read<GroupChallengeBloc>().add(
                RegisterForEventEvent(eventId: event.id),
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
        child: const Text('Register'),
      ),
    );
  }
}