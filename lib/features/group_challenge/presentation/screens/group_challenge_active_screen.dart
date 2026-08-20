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

class CurrentEventDetailScreen extends StatelessWidget {
  final GroupChallengeEntity event;

  const CurrentEventDetailScreen({super.key, required this.event});

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
    GroupChallengeEntity event,
    RequiredBookEntity book,
  ) {
    for (final p in event.userBookProgress) {
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
          event.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: BlocBuilder<GroupChallengeBloc, GroupChallengeState>(
        builder: (context, state) {
          final liveEvent = _resolveLiveEvent(state, event);
          final canTakeQuiz =
              liveEvent.userOutcome != 'won' && liveEvent.userOutcome != 'lost';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
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
                      liveEvent.description,
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
                    for (final book in liveEvent.requiredBooks)
                      _buildBookRow(
                        context,
                        liveEvent,
                        book,
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
    GroupChallengeEntity event,
    RequiredBookEntity book, {
    required bool canTakeQuiz,
  }) {
    final progress = _progressFor(event, book);

    if (event.userBookProgress.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(book.title, style: const TextStyle(fontSize: 14)),
      );
    }

    final isCompleted = progress?.isCompleted ?? false;
    final isFailed = progress?.isFailed ?? false;

    if (isCompleted) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xff54a747), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                book.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const Text(
              'Completed',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xff54a747),
              ),
            ),
          ],
        ),
      );
    }

    if (isFailed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.cancel, color: Color(0xffe74c3c), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                book.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const Text(
              'Failed',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xffe74c3c),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.circle_outlined,
            color: Color(0xff2d2d2d),
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