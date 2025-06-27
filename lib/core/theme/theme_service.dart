import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service for managing and persisting the application's theme settings.
///
/// This service allows for toggling between light and dark themes and
/// persists the user's theme preference using `SharedPreferences`.
class ThemeService extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  /// Initializes the theme service by loading the saved theme preference.
  ///
  /// This method should be called once at the application startup.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(_themeModeKey);

    if (savedThemeMode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedThemeMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  /// Toggles the current theme mode between light and dark.
  ///
  /// If the current mode is system, it will switch to light. If light, to dark.
  /// If dark, to system.
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      await prefs.setString(_themeModeKey, 'dark');
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.system;
      await prefs.setString(_themeModeKey, 'system');
    } else {
      _themeMode = ThemeMode.light;
      await prefs.setString(_themeModeKey, 'light');
    }
    notifyListeners();
  }

  /// Sets the theme mode explicitly.
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = mode;
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    await prefs.setString(_themeModeKey, modeString);
    notifyListeners();
  }
}
