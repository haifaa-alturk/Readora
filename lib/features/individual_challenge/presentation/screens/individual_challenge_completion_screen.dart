import 'package:flutter/material.dart';

class IndividualChallengeCompletionScreen extends StatelessWidget {
  final VoidCallback onStartQuiz;
  final VoidCallback onSkip;

  const IndividualChallengeCompletionScreen({
    super.key,
    required this.onStartQuiz,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
            appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Congratulations! You have finished the book.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Let's test your memory and concentration with a short quiz.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Answer the three questions correctly to earn 3 bonus points.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                      
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onStartQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfffce38a),
                          foregroundColor: const Color(0xff2d2d2d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Start Quiz'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: onSkip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                        
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
