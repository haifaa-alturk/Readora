import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/required_book_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_event.dart';
import '../bloc/group_challenge_state.dart';
import 'group_challenge_active_screen.dart';

class CurrentEventsScreen extends StatefulWidget {
  const CurrentEventsScreen({super.key});

  @override
  State<CurrentEventsScreen> createState() => _CurrentEventsScreenState();
}

class _CurrentEventsScreenState extends State<CurrentEventsScreen> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    context.read<GroupChallengeBloc>().add(const LoadCurrentEventsEvent());
  }

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

  String _summarizeBooks(List<RequiredBookEntity> books) {
    final visible = books.take(3).map((b) => b.title).join(', ');
    final extra = books.length - 3;
    if (extra > 0) return '$visible, +$extra more';
    return visible;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text(
          'Current Competitions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<GroupChallengeBloc, GroupChallengeState>(
        builder: (context, state) {
          if (state.isLoadingCurrent && state.currentEvents == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = state.currentEvents ?? const <GroupChallengeEntity>[];
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
                    'No events are currently ongoing.',
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
      decoration: BoxDecoration(
        color: const Color(0xfffce38a).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<GroupChallengeBloc>(),
                child: CurrentEventDetailScreen(event: event),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.menu_book, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _summarizeBooks(event.requiredBooks),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: event.isRegistered
                      ? _buildJoinedArea(context, event)
                      : _buildJoinButton(context, event),
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildJoinedArea(BuildContext context, GroupChallengeEntity event) {
    final canLeave = (event.userOutcome == 'ongoing' ||
            event.userOutcome == 'registered') &&
        _participationIdFor(context, event) != null;
    if (!canLeave) return _buildJoinedPill();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildJoinedPill(),
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

  Widget _buildJoinedPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff2d2d2d).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Joined',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xff2d2d2d),
        ),
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context, GroupChallengeEntity event) {
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
        child: const Text('Join'),
      ),
    );
  }
}