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
                points: event.points,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
          child: event.isRegistered
              ? _buildRegisteredArea(context, event)
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

  /// Resolves the participation id for a joined event. KNOWN LIMITATION:
  /// GET events/participations does not return participation_id, so this is
  /// only available if the user registered during the current app session.
  int? _participationIdFor(BuildContext context, GroupChallengeEntity event) {
    final state = context.read<GroupChallengeBloc>().state;
    return event.participationId ?? state.participationIdsByEventId[event.id];
  }

  Future<void> _confirmLeave(
    BuildContext context,
    GroupChallengeEntity event,
  ) async {
    final participationId = _participationIdFor(context, event);
    if (participationId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xfffcfbfa),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Leave Event',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to leave "${event.title}"? You will no longer be able to win its points.',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xffe74c3c)),
            child: const Text(
              'Leave',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<GroupChallengeBloc>().add(
            CancelParticipationEvent(participationId: participationId),
          );
    }
  }

  Widget _buildRegisteredArea(BuildContext context, GroupChallengeEntity event) {
    final canLeave = (event.userOutcome == 'registered' ||
            event.userOutcome == 'ongoing') &&
        _participationIdFor(context, event) != null;
    if (!canLeave) return _buildRegisteredPill();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRegisteredPill(),
        const SizedBox(width: 8),
        SizedBox(
          height: 34,
          child: OutlinedButton(
            onPressed: () => _confirmLeave(context, event),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xffe74c3c),
              side: BorderSide(
                color: const Color(0xffe74c3c).withValues(alpha: 0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Leave event'),
          ),
        ),
      ],
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