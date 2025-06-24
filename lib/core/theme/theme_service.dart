import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  late final StreamController<bool> _themeController;
  bool _isDarkMode = false;

  ThemeService() {
    _themeController = StreamController<bool>.broadcast();
  }
  
  Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode') ?? false;
    _isDarkMode = isDark;
    _themeController.add(isDark);
  }
  
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = !(prefs.getBool('dark_mode') ?? false);
    prefs.setBool('dark_mode', isDark);
    _isDarkMode = isDark;
    _themeController.add(isDark);
  }
  
  Stream<bool> get isDarkMode => _themeController.stream;
  ColorScheme getColorScheme() {
    return _isDarkMode ? ThemeData.dark().colorScheme : ThemeData.light().colorScheme;
  }
}