import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/individual_challenge_bloc.dart';
import '../bloc/individual_challenge_event.dart';
import '../bloc/individual_challenge_state.dart';

const Color _questionColorPink = Color(0xffFF8FAB);
const Color _questionColorGreen = Color(0xff7ED399);
const Color _questionColorYellow = Color(0xffFFD65C);
final List<Color> _questionCardColors = [_questionColorPink, _questionColorGreen, _questionColorYellow];

class IndividualChallengeQuizScreen extends StatefulWidget {
  final int bookId;
  final String bookTitle;
  final void Function(int bonusPoints) onPassed;
  final VoidCallback onFailed;

  const IndividualChallengeQuizScreen({
    super.key,
    required this.bookId,
    required this.bookTitle,
    required this.onPassed,
    required this.onFailed,
  });

  @override
  State<IndividualChallengeQuizScreen> createState() =>
      _IndividualChallengeQuizScreenState();
}

class _IndividualChallengeQuizScreenState
    extends State<IndividualChallengeQuizScreen> {
  int _visibleQuestionIndex = 0;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    context.read<IndividualChallengeBloc>().add(
          LoadIndividualChallengeEvent(
            bookId: widget.bookId,
            bookTitle: widget.bookTitle,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
            appBar: AppBar(
           backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
              elevation: 0,
              title: const Text(
                'Quiz',
                style: TextStyle(
                 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: BlocConsumer<IndividualChallengeBloc,
                IndividualChallengeState>(
              listener: (context, state) {
                if (state is IndividualChallengePassed) {
                  widget.onPassed(state.bonusPoints);
                } else if (state is IndividualChallengeFailed) {
                  widget.onFailed();
                } else if (state is IndividualChallengeSkipped) {
                  Navigator.of(context).maybePop();
                }
              },
              builder: (context, state) {
                if (state is IndividualChallengeLoading ||
                    state is IndividualChallengeInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is IndividualChallengeError) {
                  return Center(
                    child: Text(
                      state.message,
                      
                    ),
                  );
                }
                if (state is IndividualChallengeInProgress) {
                  final questions = state.challenge.questions;
                  final question = questions[_visibleQuestionIndex];
                  final answered =
                      state.selectedAnswers[_visibleQuestionIndex] != null;

                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Question ${_visibleQuestionIndex + 1} of ${questions.length}',
                          style: TextStyle(
                            fontSize: 13,
                            
                              
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.05, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildQuestionCard(
                              key: ValueKey(_visibleQuestionIndex),
                              question: question,
                              questionIndex: _visibleQuestionIndex,
                              selectedAnswer:
                                  state.selectedAnswers[_visibleQuestionIndex],
                              answered: answered,
                              totalQuestions: questions.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }

  Widget _buildQuestionCard({
    required Key key,
    required dynamic question,
    required int questionIndex,
    required int? selectedAnswer,
    required bool answered,
    required int totalQuestions,
  }) {
    return Card(
      key: key,
      color: _questionCardColors[questionIndex % _questionCardColors.length],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              final isSelected = selectedAnswer == index;
              final isCorrect = index == question.correctOptionIndex;
              final showCheck = answered && isCorrect;
              final showCross = answered && isSelected && !isCorrect;

              return GestureDetector(
                onTap: (_isLocked || answered)
                    ? null
                    : () {
                        setState(() {
                          _isLocked = true;
                        });
                      context.read<IndividualChallengeBloc>().add(
                            AnswerQuestionEvent(
                              questionIndex: questionIndex,
                              selectedOptionIndex: index,
                            ),
                          );
                        if (questionIndex < totalQuestions - 1) {
                          Future.delayed(const Duration(milliseconds: 900),
                              () {
                            if (mounted) {
                              setState(() {
                                _visibleQuestionIndex++;
                                _isLocked = false;
                              });
                            }
                          });
                        }
                      },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xfffce38a)
                          : const Color(0xff2d2d2d).withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff2d2d2d).withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: showCheck
                                ? const Color(0xff2d7d2d)
                                : showCross
                                    ? const Color(0xffc62828)
                                    : const Color(0xff2d2d2d)
                                        .withValues(alpha: 0.25),
                            width: 2,
                          ),
                          color: showCheck
                              ? const Color(0xff2d7d2d)
                              : Colors.transparent,
                        ),
                        child: showCheck
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : showCross
                                ? const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Color(0xffc62828),
                                  )
                                : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          question.options[index],
                          style: TextStyle(
                            fontSize: 15,
                            
                          ),
                        ),
                      ),
                      if (showCheck)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xff2d7d2d),
                          size: 22,
                        ),
                      if (showCross)
                        const Icon(
                          Icons.cancel,
                          color: Color(0xffc62828),
                          size: 22,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
