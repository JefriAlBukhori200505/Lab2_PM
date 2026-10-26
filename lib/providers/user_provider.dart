import 'package:flutter/foundation.dart';

/// Menyimpan nama pengguna yang sedang bermain kuis.
class UserProvider extends ChangeNotifier {
  String _name = '';

  String get name => _name;
  bool get isLoggedIn => _name.isNotEmpty;

  void login(String name) {
    _name = name.trim();
    notifyListeners();
  }

  void logout() {
    _name = '';
    notifyListeners();
  }
}
