import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_app/themes/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveTheme(themeData);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme');

    if (theme != null) {
      _themeData = theme == 'dark' ? darkMode : lightMode;
    } else {
      _themeData = lightMode; // Set default theme
    }
    notifyListeners(); // Notify listeners for initial load
  }

  Future<void> _saveTheme(ThemeData themeData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = (themeData == darkMode) ? 'dark' : 'light';
    await prefs.setString('theme', theme);
  }
}
