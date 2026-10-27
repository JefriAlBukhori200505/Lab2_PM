import 'package:flutter/material.dart';

/// Progress bar kuis dengan animasi halus (reusable).
class QuizProgressBar extends StatelessWidget {
  final double value;

  const QuizProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 400),
      builder: (context, v, _) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: v,
          minHeight: 10,
          backgroundColor: scheme.surfaceContainerHighest,
          color: scheme.primary,
        ),
      ),
    );
  }
}
