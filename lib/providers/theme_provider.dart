import 'package:flutter/material.dart';

/// Menyimpan mode tema aktif (light / dark) agar tidak hilang saat
/// perpindahan halaman maupun rotasi layar.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
