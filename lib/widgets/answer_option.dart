import 'package:flutter/material.dart';

enum AnswerState { idle, correct, wrong, dimmed }

/// Tombol pilihan jawaban berwarna ala Quizizz (reusable).
class AnswerOption extends StatelessWidget {
  final int index;
  final String text;
  final AnswerState state;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.index,
    required this.text,
    required this.state,
    this.onTap,
  });

  static const List<Color> _palette = [
    Color(0xFFE21B3C),
    Color(0xFF1368CE),
    Color(0xFFD89E00),
    Color(0xFF26890C),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = _palette[index % _palette.length];
    final width = MediaQuery.sizeOf(context).width;
    final fontSize = (width * 0.04).clamp(14.0, 18.0);

    var background = base;
    var foreground = Colors.white;
    Border? border;
    Widget? trailing;

    switch (state) {
      case AnswerState.idle:
        break;
      case AnswerState.correct:
        border = Border.all(color: scheme.onSurface, width: 3);
        trailing = const Icon(Icons.check_circle_rounded, color: Colors.white);
        break;
      case AnswerState.wrong:
        background = base.withValues(alpha: 0.6);
        trailing = const Icon(Icons.cancel_rounded, color: Colors.white);
        break;
      case AnswerState.dimmed:
        background = base.withValues(alpha: 0.25);
        foreground = scheme.onSurface.withValues(alpha: 0.6);
        break;
    }

    final letter = String.fromCharCode(65 + index); // A, B, C, D

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: foreground.withValues(alpha: 0.25),
                    child: Text(
                      letter,
                      style: TextStyle(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: foreground,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
