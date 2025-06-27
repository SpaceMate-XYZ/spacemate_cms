import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemate/core/theme/theme_service.dart';

void main() {
  late ThemeService themeService;

  setUp(() {
    themeService = ThemeService();
  });

  tearDown(() {
    themeService.dispose();
  });

  group('ThemeService', () {
    test('initTheme loads dark mode preference correctly', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});

      // Act
      await themeService.init();

      // Assert
      expect(themeService.themeMode, ThemeMode.dark);
    });

    test('initTheme defaults to system mode if no preference is saved', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({}); // No 'theme_mode' key

      // Act
      await themeService.init();

      // Assert
      expect(themeService.themeMode, ThemeMode.system);
    });

    test('toggleTheme cycles through theme modes and saves preference', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      await themeService.init(); // Initialize with light mode
      
      // Act - First toggle (light -> dark)
      await themeService.toggleTheme();
      expect(themeService.themeMode, ThemeMode.dark);
      
      // Act - Second toggle (dark -> system)
      await themeService.toggleTheme();
      expect(themeService.themeMode, ThemeMode.system);
      
      // Act - Third toggle (system -> light)
      await themeService.toggleTheme();
      expect(themeService.themeMode, ThemeMode.light);

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'light');
    });

    test('toggleTheme switches to light mode and saves preference', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
      await themeService.init(); // Initialize with dark mode

      // Act
      await themeService.toggleTheme();

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(themeService.themeMode, ThemeMode.system);
      expect(prefs.getString('theme_mode'), 'system');
    });

    test('setThemeMode updates theme mode and saves preference', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      await themeService.init();

      // Act
      await themeService.setThemeMode(ThemeMode.dark);

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(themeService.themeMode, ThemeMode.dark);
      expect(prefs.getString('theme_mode'), 'dark');
    });

    test('themeMode changes correctly on toggle', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      await themeService.init();
      
      // Act & Assert - First toggle (light -> dark)
      await themeService.toggleTheme();
      expect(themeService.themeMode, ThemeMode.dark);
      
      // Second toggle (dark -> system)
      await themeService.toggleTheme();
      expect(themeService.themeMode, ThemeMode.system);
      
      // Third toggle (system -> light)
      await themeService.toggleTheme();
      expect(themeService.themeMode, ThemeMode.light);
    });
  });
}