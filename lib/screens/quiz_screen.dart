import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/answer_option.dart';
import '../widgets/primary_button.dart';
import '../widgets/quiz_progress_bar.dart';
import '../widgets/theme_toggle_button.dart';
import 'login_screen.dart';
import 'result_screen.dart';

/// Satu halaman yang dipakai ulang untuk semua soal.
/// Progres disimpan di QuizProvider sehingga aman saat layar diputar.
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  Future<void> _confirmExit(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari kuis?'),
        content: const Text('Progres jawabanmu akan hilang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjut Main'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<UserProvider>().logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _onNext(BuildContext context) {
    final quiz = context.read<QuizProvider>();
    if (quiz.isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    } else {
      quiz.next();
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final size = MediaQuery.sizeOf(context);
    final hPad = (size.width * 0.05).clamp(16.0, 32.0);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.close_rounded),
            onPressed: () => _confirmExit(context),
          ),
          title: Text('Soal ${quiz.currentIndex + 1} dari ${quiz.total}'),
          actions: [
            Chip(
              avatar: const Icon(Icons.check_circle_rounded, size: 18),
              label: Text('${quiz.correctCount}'),
            ),
            const SizedBox(width: 8),
            const ThemeToggleButton(),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
                child: Column(
                  children: [
                    QuizProgressBar(value: quiz.progress),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          ),
                          child: _QuestionContent(
                            key: ValueKey(quiz.currentIndex),
                            quiz: quiz,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tombol selalu menempati ruang agar layout tidak melompat.
                    Visibility(
                      visible: quiz.isAnswered,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: PrimaryButton(
                        text: quiz.isLast ? 'Lihat Skor' : 'Lanjut',
                        icon: quiz.isLast
                            ? Icons.emoji_events_rounded
                            : Icons.arrow_forward_rounded,
                        onPressed: () => _onNext(context),
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

class _QuestionContent extends StatelessWidget {
  final QuizProvider quiz;

  const _QuestionContent({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final question = quiz.currentQuestion;

    final options = List<Widget>.generate(question.options.length, (i) {
      final AnswerState state;
      if (!quiz.isAnswered) {
        state = AnswerState.idle;
      } else if (i == question.correctIndex) {
        state = AnswerState.correct;
      } else if (i == quiz.selectedAnswer) {
        state = AnswerState.wrong;
      } else {
        state = AnswerState.dimmed;
      }
      return AnswerOption(
        index: i,
        text: question.options[i],
        state: state,
        onTap: quiz.isAnswered ? null : () => quiz.selectAnswer(i),
      );
    });

    final isCorrect = quiz.selectedAnswer == question.correctIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            question.text,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = 12.0;
            // Layar lebar (tablet/web): grid 2 kolom. Layar sempit: 1 kolom.
            if (constraints.maxWidth >= 560) {
              final w = (constraints.maxWidth - gap) / 2;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final o in options) SizedBox(width: w, child: o),
                ],
              );
            }
            return Column(
              children: [
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0) const SizedBox(height: gap),
                  options[i],
                ],
              ],
            );
          },
        ),
        if (quiz.isAnswered) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isCorrect
                  ? scheme.primaryContainer
                  : scheme.errorContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  isCorrect ? Icons.thumb_up_rounded : Icons.info_rounded,
                  color: isCorrect
                      ? scheme.onPrimaryContainer
                      : scheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isCorrect
                        ? 'Jawaban benar!'
                        : 'Kurang tepat. Jawaban benar: ${question.options[question.correctIndex]}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isCorrect
                          ? scheme.onPrimaryContainer
                          : scheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}
