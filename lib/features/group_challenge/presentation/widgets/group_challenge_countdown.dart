import 'dart:async';

import 'package:flutter/material.dart';

class GroupChallengeCountdown extends StatefulWidget {
  final DateTime deadline;
  final VoidCallback? onFinished;

  const GroupChallengeCountdown({super.key, required this.deadline, this.onFinished});

  @override
  State<GroupChallengeCountdown> createState() =>
      _GroupChallengeCountdownState();
}

class _GroupChallengeCountdownState extends State<GroupChallengeCountdown> {
  late Duration _remaining;
  Timer? _timer;
  bool _hasFired = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.deadline.difference(DateTime.now());
    if (_remaining.isNegative) {
      _remaining = Duration.zero;
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final updated = widget.deadline.difference(DateTime.now());
        if (updated.isNegative) {
          _timer?.cancel();
          if (!_hasFired) {
            _hasFired = true;
            widget.onFinished?.call();
          }
          if (mounted) {
            setState(() => _remaining = Duration.zero);
          }
        } else if (mounted) {
          setState(() => _remaining = updated);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final minutes = _remaining.inMinutes.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xff2d2d2d).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, size: 16, color: Color(0xff2d2d2d)),
          const SizedBox(width: 6),
          Text(
            '${days}d ${hours}h ${minutes}m',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff2d2d2d),
            ),
          ),
        ],
      ),
    );
  }
}
