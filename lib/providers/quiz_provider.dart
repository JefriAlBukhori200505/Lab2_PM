import 'package:flutter/foundation.dart';

import '../data/dummy_questions.dart';
import '../models/question.dart';

/// Menyimpan progres kuis (soal aktif dan jawaban) agar tidak hilang
/// saat layar diputar atau berpindah halaman.
class QuizProvider extends ChangeNotifier {
  List<Question> _questions = List.of(dummyQuestions);
  int _currentIndex = 0;
  final Map<int, int> _answers = {}; // index soal -> index jawaban dipilih

  List<Question> get questions => _questions;
  int get total => _questions.length;
  int get currentIndex => _currentIndex;
  Question get currentQuestion => _questions[_currentIndex];

  int? get selectedAnswer => _answers[_currentIndex];
  bool get isAnswered => _answers.containsKey(_currentIndex);
  bool get isLast => _currentIndex == total - 1;

  int get correctCount {
    var count = 0;
    _answers.forEach((qIndex, answer) {
      if (_questions[qIndex].correctIndex == answer) count++;
    });
    return count;
  }

  int get wrongCount => _answers.length - correctCount;

  /// Skor akhir skala 0-100.
  int get score => total == 0 ? 0 : (correctCount * 100 / total).round();

  /// Progres bar: soal yang sudah dijawab dihitung selesai.
  double get progress =>
      total == 0 ? 0 : (_currentIndex + (isAnswered ? 1 : 0)) / total;

  void selectAnswer(int index) {
    if (isAnswered) return;
    _answers[_currentIndex] = index;
    notifyListeners();
  }

  void next() {
    if (!isAnswered || isLast) return;
    _currentIndex++;
    notifyListeners();
  }

  /// Mulai ulang kuis dengan urutan soal diacak.
  void reset() {
    _questions = List.of(dummyQuestions)..shuffle();
    _currentIndex = 0;
    _answers.clear();
    notifyListeners();
  }
}
