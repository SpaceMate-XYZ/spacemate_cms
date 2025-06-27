import 'package:flutter/material.dart';

/// Defines the color palette for the SpaceMate application.
///
/// This class provides static `ColorScheme` instances for both light and dark
/// themes, as well as a `seedColor` for generating dynamic color schemes.
///
/// The `seedColor` is used by `DynamicColor` to generate a harmonious color
/// palette based on a single input color, which can then be adapted to
/// the user's device theme settings.
class AppColors {
  /// The primary seed color for generating dynamic color schemes.
  /// This color serves as the base for the entire application's color palette.
  static const Color seedColor = Color(0xFF6750A4); // A shade of deep purple

  /// Returns a light `ColorScheme` based on the `seedColor`.
  ///
  /// This scheme is used for the default light theme of the application.
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  /// Returns a dark `ColorScheme` based on the `seedColor`.
  ///
  /// This scheme is used for the default dark theme of the application.
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  // You can also define custom, non-dynamic colors here if needed,
  // for specific UI elements that don't follow the dynamic scheme.
  // Example:
  // static const Color customRed = Color(0xFFEF5350);
}