import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/stat_card.dart';
import '../widgets/theme_toggle_button.dart';
import 'login_screen.dart';
import 'quiz_screen.dart';

/// Halaman skor akhir.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  String _message(int score) {
    if (score >= 80) return 'Luar biasa!';
    if (score >= 50) return 'Bagus, terus berlatih!';
    return 'Jangan menyerah, coba lagi!';
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final name = context.watch<UserProvider>().name;
    final scheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);

    final circleSize = (size.shortestSide * 0.5).clamp(160.0, 240.0);
    final hPad = (size.width * 0.06).clamp(20.0, 48.0);
    final score = quiz.score;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hasil Kuis'),
        actions: const [ThemeToggleButton(), SizedBox(width: 12)],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _message(score),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [scheme.primary, scheme.tertiary],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SKOR',
                            style: TextStyle(
                              color: scheme.onPrimary.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: score),
                            duration: const Duration(milliseconds: 1200),
                            builder: (context, value, _) => Text(
                              '$value',
                              style: TextStyle(
                                color: scheme.onPrimary,
                                fontSize: circleSize * 0.35,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.check_circle_rounded,
                          label: 'Benar',
                          value: '${quiz.correctCount}',
                          color: const Color(0xFF26890C),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.cancel_rounded,
                          label: 'Salah',
                          value: '${quiz.wrongCount}',
                          color: scheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    text: 'Main Lagi',
                    icon: Icons.replay_rounded,
                    onPressed: () {
                      context.read<QuizProvider>().reset();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const QuizScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Keluar'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        context.read<UserProvider>().logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
