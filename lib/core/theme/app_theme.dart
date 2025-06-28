import 'package:flutter/material.dart';

import 'package:spacemate/core/theme/app_colors.dart';
import 'package:spacemate/core/theme/app_text_styles.dart';

/// Defines the application's themes (light and dark).
///
/// This class provides static `ThemeData` instances that incorporate the
/// defined color schemes from `AppColors` and text styles from `AppTextStyles`.
/// It also integrates `DynamicColor` to allow for adaptive theming based on
/// the user's device settings.
class AppTheme {
  /// Returns the light `ThemeData` for the application.
  ///
  /// If `newColors` are provided (from `DynamicColorPlugin`), they will be
  /// used to generate the `ColorScheme`. Otherwise, the default light
  /// `ColorScheme` from `AppColors` will be used.
  static ThemeData lightTheme([ColorScheme? newColors]) {
    final ColorScheme colorScheme = newColors ?? AppColors.lightColorScheme;

    final baseTheme = ThemeData.light(useMaterial3: true);
    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      cardTheme: baseTheme.cardTheme.copyWith(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        surfaceTintColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  /// Returns the dark `ThemeData` for the application.
  ///
  /// Similar to `lightTheme`, it uses `newColors` if available, otherwise
  /// falls back to the default dark `ColorScheme` from `AppColors`.
  static ThemeData darkTheme([ColorScheme? newColors]) {
    final ColorScheme colorScheme = newColors ?? AppColors.darkColorScheme;

    final baseTheme = ThemeData.dark(useMaterial3: true);
    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      cardTheme: baseTheme.cardTheme.copyWith(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        surfaceTintColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
