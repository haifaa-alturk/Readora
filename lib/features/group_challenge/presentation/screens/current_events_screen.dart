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
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
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
                      ? _buildJoinedPill()
                      : _buildJoinButton(context, event),
                ),
              ],
            ),
          ),
        ),
      ),
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