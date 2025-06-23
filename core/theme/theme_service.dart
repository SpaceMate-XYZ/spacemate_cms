import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class ThemeService {
  static Future<ThemeData> getTheme({bool isDark = false}) async {
    final corePalette = await DynamicColorPlugin.getCorePalette();
    final brightness = isDark ? Brightness.dark : Brightness.light;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: _getColorScheme(corePalette, brightness),
      brightness: brightness,
      // Add other theme properties here
    );
  }

  static ColorScheme _getColorScheme(CorePalette? corePalette, Brightness brightness) {
    if (corePalette == null) {
      // Fallback colors if dynamic colors are not available
      return brightness == Brightness.dark
          ? const ColorScheme.dark()
          : const ColorScheme.light();
    }

    return ColorScheme.fromSeed(
      seedColor: corePalette.primary.get(40),
      brightness: brightness,
      primary: corePalette.primary.get(40),
      onPrimary: corePalette.primary.get(100),
      primaryContainer: corePalette.primary.get(90),
      onPrimaryContainer: corePalette.primary.get(10),
      secondary: corePalette.secondary.get(40),
      onSecondary: corePalette.secondary.get(100),
      secondaryContainer: corePalette.secondary.get(90),
      onSecondaryContainer: corePalette.secondary.get(10),
      error: corePalette.error.get(40),
      onError: corePalette.error.get(100),
      errorContainer: corePalette.error.get(90),
      onErrorContainer: corePalette.error.get(10),
      background: corePalette.neutral.get(99),
      onBackground: corePalette.neutral.get(10),
      surface: corePalette.neutral.get(99),
      onSurface: corePalette.neutral.get(10),
      surfaceVariant: corePalette.neutralVariant.get(90),
      onSurfaceVariant: corePalette.neutralVariant.get(30),
    );
  }
}
