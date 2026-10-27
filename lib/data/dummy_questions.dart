import '../models/question.dart';

/// Data soal lokal (dummy), tanpa database.
const List<Question> dummyQuestions = [
  Question(
    text: 'Bahasa pemrograman apa yang digunakan untuk membuat aplikasi Flutter?',
    options: ['Kotlin', 'Dart', 'Swift', 'Java'],
    correctIndex: 1,
  ),
  Question(
    text: 'Widget yang tampilannya tidak berubah setelah dibuat disebut...',
    options: [
      'StatefulWidget',
      'InheritedWidget',
      'StatelessWidget',
      'ChangeWidget',
    ],
    correctIndex: 2,
  ),
  Question(
    text: 'Method yang dipakai untuk memperbarui tampilan pada StatefulWidget adalah...',
    options: ['build()', 'initState()', 'dispose()', 'setState()'],
    correctIndex: 3,
  ),
  Question(
    text: 'Widget yang menyusun anak-anaknya secara vertikal adalah...',
    options: ['Row', 'Column', 'Stack', 'Wrap'],
    correctIndex: 1,
  ),
  Question(
    text: 'File konfigurasi untuk mendaftarkan dependency, aset, dan font adalah...',
    options: ['main.dart', 'AndroidManifest.xml', 'pubspec.yaml', 'README.md'],
    correctIndex: 2,
  ),
  Question(
    text: 'Perintah untuk mengunduh semua dependency project Flutter adalah...',
    options: [
      'flutter pub get',
      'flutter build',
      'flutter create',
      'flutter doctor',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'Widget yang menumpuk anak-anaknya di atas satu sama lain adalah...',
    options: ['ListView', 'Column', 'Container', 'Stack'],
    correctIndex: 3,
  ),
  Question(
    text: 'Package yang dipakai di aplikasi ini untuk state management adalah...',
    options: ['Provider', 'Dio', 'Hive', 'Lottie'],
    correctIndex: 0,
  ),
];
