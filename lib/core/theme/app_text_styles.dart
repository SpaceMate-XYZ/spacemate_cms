import 'package:flutter/material.dart';

/// Defines the typography for the SpaceMate application.
///
/// This class provides a static `TextTheme` that can be used across the
/// application to ensure consistent text styling. It leverages Google Fonts
/// for a modern and readable typeface.
class AppTextStyles {
  /// Returns a `TextTheme` configured with the 'Roboto' font.
  ///
  /// This `TextTheme` includes various text styles (headline, title, body, etc.)
  /// that can be directly applied to `Text` widgets or used within `ThemeData`.
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.w400),
      displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w400),

      headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),

      titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),

      bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),

      labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
    );
  }
}