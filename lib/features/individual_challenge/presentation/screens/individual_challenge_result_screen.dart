import 'package:flutter/material.dart';

class IndividualChallengeResultScreen extends StatelessWidget {
  final bool isPass;
  final int? bonusPoints;
  final VoidCallback onDone;

  const IndividualChallengeResultScreen({
    super.key,
    required this.isPass,
    this.bonusPoints,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 420,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Scaffold(
            backgroundColor: const Color(0xfffcfbfa),
            appBar: AppBar(
              backgroundColor: const Color(0xfffcfbfa),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onDone,
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // PLACEHOLDER illustration — replace with real asset later
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xff2d2d2d).withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isPass ? Icons.emoji_events : Icons.menu_book,
                        size: 56,
                        color: const Color(0xff2d2d2d).withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isPass) ...[
                      const Text(
                        'Congratulations!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2d2d2d),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You passed the challenge and earned 3 bonus points.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color(0xff2d2d2d).withValues(alpha: 0.7),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        "Unfortunately you didn't pass this challenge.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2d2d2d),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Don't be discouraged.\nThere are many more books and challenges waiting for you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff2d2d2d),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onDone,
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
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
