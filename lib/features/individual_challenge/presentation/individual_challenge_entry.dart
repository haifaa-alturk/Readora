import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/individual_challenge_bloc.dart';
import '../domain/repositories/individual_challenge_repository_interface.dart';
import 'screens/individual_challenge_completion_screen.dart';
import 'screens/individual_challenge_quiz_screen.dart';
import 'screens/individual_challenge_result_screen.dart';
import '../../wins/presentation/bloc/wins_bloc.dart';
import '../../wins/presentation/bloc/wins_event.dart';
import '../../wins/domain/entities/win_entity.dart';
import '../../points/presentation/bloc/points_bloc.dart';
import '../../points/presentation/bloc/points_event.dart';
import '../../group_challenge/presentation/bloc/group_challenge_bloc.dart';
import '../../group_challenge/presentation/bloc/group_challenge_event.dart';

Future<void> openIndividualChallengeFlow(
  BuildContext context, {
  required int bookId,
  required String bookTitle,
}) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (completionContext) => IndividualChallengeCompletionScreen(
        onSkip: () => Navigator.of(completionContext).pop(),
        onStartQuiz: () {
          Navigator.of(completionContext).push(
            MaterialPageRoute(
              builder: (quizContext) => BlocProvider(
                create: (_) => IndividualChallengeBloc(
                  repository: context.read<IndividualChallengeRepositoryInterface>(),
                ),
                child: IndividualChallengeQuizScreen(
                  bookId: bookId,
                  bookTitle: bookTitle,
                  onPassed: (points) {
                    context.read<WinsBloc>().add(ReceiveNewWinEvent(
                      win: WinEntity(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: '$bookTitle Challenge',
                        description: 'Completed',
                        iconName: 'emoji_events',
                        dateEarned: DateTime.now(),
                        type: 'individual_challenge',
                        challengeId: bookId,
                        challengeType: 'individual',
                        reward: '3 bonus points',
                        earnedPoints: 3,
                        completedDate: DateTime.now(),
                        status: 'completed',
                      ),
                    ));
                    // Points are awarded server-side by the quiz submission — refresh the
                    // Points feature from the server (GET user/points_history) to pick them up,
                    // instead of faking a local increment.
                    context.read<PointsBloc>().add(const LoadPointsEvent());
                    // This book's Individual Challenge quiz was just passed — count it toward any Group Challenge the user has joined. Safe to call unconditionally; the Bloc ignores this if there's no active joined challenge.
                    context.read<GroupChallengeBloc>().add(const RecordBookCompletionEvent());
                    Navigator.of(quizContext).push(
                      MaterialPageRoute(
                        builder: (_) => IndividualChallengeResultScreen(
                          isPass: true,
                          bonusPoints: points,
                          onDone: () =>
                              Navigator.of(context).popUntil((route) => route.isFirst),
                        ),
                      ),
                    );
                  },
                  onFailed: () {
                    Navigator.of(quizContext).push(
                      MaterialPageRoute(
                        builder: (_) => IndividualChallengeResultScreen(
                          isPass: false,
                          onDone: () =>
                              Navigator.of(context).popUntil((route) => route.isFirst),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
