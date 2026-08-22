import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_event.dart';
import '../bloc/group_challenge_state.dart';
import '../widgets/group_challenge_countdown.dart';
import 'group_challenge_active_screen.dart';
import 'group_challenge_winners_screen.dart';

class MyCompetitionsScreen extends StatefulWidget {
  const MyCompetitionsScreen({super.key});

  @override
  State<MyCompetitionsScreen> createState() => _MyCompetitionsScreenState();
}

class _MyCompetitionsScreenState extends State<MyCompetitionsScreen> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _selectedTab = 'ongoing';

  /// Won events only get their joined_at / finished_at timestamps from the
  /// live completed-event detail endpoint (GET events/completed/{id}), so
  /// fetch details for any won event whose dates aren't cached yet.
  /// Dispatched post-frame to avoid modifying state during build; cards
  /// render instantly with fallback text and update when data arrives.
  void _ensureWonEventDetails(
    BuildContext context,
    GroupChallengeState state,
    List<GroupChallengeEntity> wonEvents,
  ) {
    final missing = wonEvents
        .where((e) => !state.participationDatesByEventId.containsKey(e.id))
        .toList();
    if (missing.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final event in missing) {
        context.read<GroupChallengeBloc>().add(LoadEventDetailEvent(
              eventId: event.id,
              status: 'completed',
            ));
      }
    });
  }

  /// Resolves the participation id for a joined event. KNOWN LIMITATION:
  /// GET events/participations does not return participation_id, so this is
  /// only available if the user registered during the current app session
  /// (the bloc caches the id from the register response).
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

  Widget _buildLeaveButton(BuildContext context, GroupChallengeEntity event) {
    return SizedBox(
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
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: const Text('Leave event'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<GroupChallengeBloc>().add(const LoadMyEventsEvent());
  }

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

  void _openDetail(BuildContext context, GroupChallengeEntity event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<GroupChallengeBloc>(),
          child: CurrentEventDetailScreen(event: event),
        ),
      ),
    );
  }

  void _openWinners(BuildContext context, GroupChallengeEntity event) {
    // One backend call (GET events/completed/{id}) provides both the winners
    // list and this user's per-book progress for the detail screen.
    context.read<GroupChallengeBloc>().add(LoadEventWinnersEvent(eventId: event.id));
    context.read<GroupChallengeBloc>().add(LoadEventDetailEvent(
          eventId: event.id,
          status: 'completed',
        ));
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
          'My Competitions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<GroupChallengeBloc, GroupChallengeState>(
        builder: (context, state) {
          if (state.isLoadingMy && state.myEvents == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = state.myEvents ?? const <GroupChallengeEntity>[];
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
                    "You haven't joined any competitions yet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final won = events.where((e) => e.userOutcome == 'won').toList();
          if (won.isNotEmpty) {
            _ensureWonEventDetails(context, state, won);
          }
          final lost = events.where((e) => e.userOutcome == 'lost').toList();
          final ongoing = events.where((e) => e.userOutcome == 'ongoing').toList();
          final registered =
              events.where((e) => e.userOutcome == 'registered').toList();

          final tabs = <_TabSpec>[
            _TabSpec('ongoing', 'Ongoing', const Color(0xffFFA754), const Color(0xffCC7A2E)),
            _TabSpec('won', 'Won', const Color(0xffC2E7D9), const Color(0xff5FAE85)),
            _TabSpec('lost', 'Lost', const Color(0xfff2d9d9), const Color(0xffD98C8C)),
            _TabSpec(
              'registered',
              'Registered',
              const Color(0xffD4C5F9),
              const Color(0xff9B7FE8),
            ),
          ];

          final selectedList = switch (_selectedTab) {
            'won' => won,
            'lost' => lost,
            'registered' => registered,
            _ => ongoing,
          };

          final emptyMessage = switch (_selectedTab) {
            'won' => "You haven't won any competitions yet.",
            'lost' => 'No lost competitions.',
            'registered' => 'No upcoming registrations.',
            _ => 'No ongoing competitions.',
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    for (var i = 0; i < tabs.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _selectedTab = tabs[i].key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedTab == tabs[i].key
                                ? tabs[i].color
                                : tabs[i].color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: tabs[i].borderColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            tabs[i].label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _selectedTab == tabs[i].key
                                  ? Colors.white
                                  : const Color(0xff2d2d2d),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: selectedList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            emptyMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (_selectedTab == 'won')
                            ...won.map((e) => _buildWonCard(context, e)),
                          if (_selectedTab == 'lost')
                            ...lost.map((e) => _buildLostCard(context, e)),
                          if (_selectedTab == 'ongoing')
                            ...ongoing.map((e) => _buildOngoingCard(context, e)),
                          if (_selectedTab == 'registered')
                            ...registered.map((e) => _buildRegisteredCard(context, e)),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Numeric date format (DD/MM/YYYY) used on the Won card.
  String _formatDateNumeric(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  Widget _buildWonCard(BuildContext context, GroupChallengeEntity event) {
    // Dates come from the live completed-event payload (joined_at /
    // finished_at), cached in state; userWonDate is a legacy fallback.
    final state = context.read<GroupChallengeBloc>().state;
    final dates = event.joinedAt != null || event.finishedAt != null
        ? (joinedAt: event.joinedAt, finishedAt: event.finishedAt)
        : state.participationDatesByEventId[event.id];
    final joinedDate = dates?.joinedAt;
    final wonDate = dates?.finishedAt ?? event.userWonDate;
    return _buildCard(
      context: context,
      color: const Color(0xffC2E7D9),
      onTap: () => _openWinners(context, event),
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
                const SizedBox(height: 4),
                Text(
                  'Started: ${_formatDateNumeric(event.startDate)}',
                  style: const TextStyle(fontSize: 13),
                ),
                if (joinedDate != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Participated since: ${_formatDateNumeric(joinedDate)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
                const SizedBox(height: 2),
                if (wonDate != null)
                  Text(
                    'Won on: ${_formatDateNumeric(wonDate)}',
                    style: const TextStyle(fontSize: 13),
                  )
                else
                  const Text(
                    'Won Competition',
                    style: TextStyle(fontSize: 13),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '+${event.userPointsEarned ?? event.points} pts',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildLostCard(BuildContext context, GroupChallengeEntity event) {
    return _buildCard(
      context: context,
      color: const Color(0xfff2d9d9),
      onTap: () => _openWinners(context, event),
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
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'You lost this competition.',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildOngoingCard(BuildContext context, GroupChallengeEntity event) {
    final completed =
        event.userBookProgress.where((p) => p.isCompleted).length;
    final total = event.requiredBooks.length;
    final progress = total > 0 ? completed / total : 0.0;

    return _buildCard(
      context: context,
      color: const Color(0xffFFA754).withValues(alpha: 0.12),
      onTap: () => _openDetail(context, event),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GroupChallengeCountdown(deadline: event.endDate),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$completed/$total books completed',
            style: const TextStyle(fontSize: 14),
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
          if (event.isRegistered &&
              (event.userOutcome == 'ongoing' ||
                  event.userOutcome == 'registered') &&
              _participationIdFor(context, event) != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: _buildLeaveButton(context, event),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegisteredCard(BuildContext context, GroupChallengeEntity event) {
    return _buildCard(
      context: context,
      color: const Color(0xffD4C5F9),
      onTap: () => _showRegisteredDetail(context, event),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              if (event.isRegistered &&
                  (event.userOutcome == 'ongoing' ||
                      event.userOutcome == 'registered') &&
                  _participationIdFor(context, event) != null)
                _buildLeaveButton(context, event),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Starts ${_formatDate(event.startDate)}',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showRegisteredDetail(BuildContext context, GroupChallengeEntity event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xfffcfbfa),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff2d2d2d).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                event.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.event, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Required Books', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              for (final book in event.requiredBooks)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(book.title, style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              const Text('Points', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                '${event.points} pts',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required Color color,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}

class _TabSpec {
  final String key;
  final String label;
  final Color color;
  final Color borderColor;

  const _TabSpec(this.key, this.label, this.color, this.borderColor);
}