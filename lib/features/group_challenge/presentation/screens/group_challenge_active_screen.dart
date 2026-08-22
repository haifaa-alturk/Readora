import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../individual_challenge/presentation/individual_challenge_entry.dart';
import '../../domain/entities/book_progress_entity.dart';
import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/entities/required_book_entity.dart';
import '../bloc/group_challenge_bloc.dart';
import '../bloc/group_challenge_event.dart';
import '../bloc/group_challenge_state.dart';
import '../widgets/group_challenge_countdown.dart';

const Color _boxOneOrange = Color(0xffFFA754);
const Color _boxTwoGreen = Color(0xff7ED399);
const Color _boxThreePurple = Color(0xffC299FC);

class CurrentEventDetailScreen extends StatefulWidget {
  final GroupChallengeEntity event;

  const CurrentEventDetailScreen({super.key, required this.event});

  @override
  State<CurrentEventDetailScreen> createState() =>
      _CurrentEventDetailScreenState();
}

class _CurrentEventDetailScreenState
    extends State<CurrentEventDetailScreen> {
  @override
  void initState() {
    super.initState();
    // This screen is only opened for ongoing/completed events.
    context.read<GroupChallengeBloc>().add(LoadEventDetailEvent(
          eventId: widget.event.id,
          status: widget.event.status,
        ));
  }

  GroupChallengeEntity _resolveLiveEvent(
    GroupChallengeState state,
    GroupChallengeEntity fallback,
  ) {
    final current = state.currentEvents;
    if (current == null) return fallback;
    for (final e in current) {
      if (e.id == fallback.id) return e;
    }
    return fallback;
  }

  BookProgressEntity? _progressFor(
    List<BookProgressEntity> progressList,
    RequiredBookEntity book,
  ) {
    for (final p in progressList) {
      if (p.bookId == book.bookId) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: Text(
          widget.event.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: BlocBuilder<GroupChallengeBloc, GroupChallengeState>(
        builder: (context, state) {
          final liveEvent = _resolveLiveEvent(state, widget.event);
          final canTakeQuiz =
              liveEvent.userOutcome != 'won' && liveEvent.userOutcome != 'lost';

          // Per-book progress comes from the dedicated detail endpoint
          // (state.eventDetail), not from the list-level calls which leave
          // userBookProgress empty.
          final detail = state.eventDetail;
          final detailForThisEvent =
              detail != null && detail.id == widget.event.id ? detail : null;
          final progressList =
              detailForThisEvent?.userBookProgress ?? const <BookProgressEntity>[];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInstructionsBanner(),
              if (liveEvent.userOutcome == 'lost')
                _buildLostBanner(),
              if (liveEvent.userOutcome == 'won')
                _buildWonBanner(liveEvent),
              _buildInfoCard(
                color: _boxOneOrange,
                icon: Icons.info_outline,
                heading: 'About This Competition',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      liveEvent.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${liveEvent.requiredBooks.length} required books',
                      style: const TextStyle(fontSize: 14),
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
                    deadline: liveEvent.endDate,
                    onFinished: () => context
                        .read<GroupChallengeBloc>()
                        .add(const LoadCurrentEventsEvent()),
                  ),
                ),
              ),
              _buildInfoCard(
                color: _boxThreePurple,
                icon: Icons.menu_book,
                heading: 'Required Books',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.isLoadingDetail && progressList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    else
                      for (final book in liveEvent.requiredBooks)
                        _buildBookRow(
                          context,
                          book,
                          progress: _progressFor(progressList, book),
                          canTakeQuiz: canTakeQuiz,
                        ),
                  ],
                ),
              ),
              if (!liveEvent.isRegistered)
                _buildJoinButtons(context, liveEvent),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInstructionsBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfff3efe6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2d2d2d).withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: Color(0xff8a7a52)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'To win the challenges, you must read all the specified books for each challenge and answer all of their quiz questions correctly and completely within the exclusively specified challenge period. Note: Missing just one question in a single quiz for any of the challenge books means you will lose the challenge. Therefore, read the books carefully so you can answer all questions correctly. We wish you an exciting experience!',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xff4a4436),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLostBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffe74c3c).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffe74c3c).withValues(alpha: 0.4),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.cancel, color: Color(0xffe74c3c)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'You lost this competition — one of the required book quizzes was not passed.',
              style: TextStyle(
                color: Color(0xffe74c3c),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWonBanner(GroupChallengeEntity event) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfffce38a).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xfff1c40f).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Color(0xffb8860b)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You won this competition! +${event.userPointsEarned} points',
              style: const TextStyle(
                color: Color(0xff7a5c00),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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

  Widget _buildBookRow(
    BuildContext context,
    RequiredBookEntity book, {
    BookProgressEntity? progress,
    required bool canTakeQuiz,
  }) {
    final coverUrl = book.coverUrl;
    final isCompleted = progress?.isCompleted ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (coverUrl != null && coverUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                coverUrl,
                width: 34,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 34,
                  height: 48,
                  color: const Color(0xff2d2d2d).withValues(alpha: 0.08),
                  child: const Icon(Icons.menu_book, size: 16),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: isCompleted ? const Color(0xff54a747) : const Color(0xff2d2d2d),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(book.title, style: const TextStyle(fontSize: 14)),
          ),
          TextButton(
            onPressed: canTakeQuiz
                ? () => openIndividualChallengeFlow(
                      context,
                      bookId: book.bookId,
                      bookTitle: book.title,
                    )
                : null,
            child: const Text(
              'Start Quiz',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButtons(BuildContext context, GroupChallengeEntity event) {
    return SizedBox(
      width: double.infinity,
      height: 50,
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
        child: const Text('Convince Me! I Want To Join'),
      ),
    );
  }
}