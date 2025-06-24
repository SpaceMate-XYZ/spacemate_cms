import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

ColorScheme getColorScheme({CorePalette? corePalette, bool isDark = false}) {
  final brightness = isDark ? Brightness.dark : Brightness.light;
  if (corePalette == null) {
    // Fallback colors if dynamic colors are not available
    return brightness == Brightness.dark
        ? const ColorScheme.dark()
        : const ColorScheme.light();
  }

  return ColorScheme.fromSeed(
    seedColor: Color(corePalette.primary.get(40)),
    brightness: brightness,
    primary: Color(corePalette.primary.get(40)),
    onPrimary: Color(corePalette.primary.get(100)),
    primaryContainer: Color(corePalette.primary.get(90)),
    onPrimaryContainer: Color(corePalette.primary.get(10)),
    secondary: Color(corePalette.secondary.get(40)),
    onSecondary: Color(corePalette.secondary.get(100)),
    secondaryContainer: Color(corePalette.secondary.get(90)),
    onSecondaryContainer: Color(corePalette.secondary.get(10)),
    error: Color(corePalette.error.get(40)),
    onError: Color(corePalette.error.get(100)),
    errorContainer: Color(corePalette.error.get(90)),
    onErrorContainer: Color(corePalette.error.get(10)),
    surface: Color(corePalette.neutral.get(99)),
    onSurface: Color(corePalette.neutral.get(10)),
    surfaceContainerHighest: Color(corePalette.neutralVariant.get(70)),
    onSurfaceVariant: Color(corePalette.neutralVariant.get(30)),
  );
}
