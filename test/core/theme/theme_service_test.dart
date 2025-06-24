import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import '../../../core/theme/color_schemes.dart';

void main() {
  group('getColorScheme', () {
    test('returns a light color scheme when isDark is false and corePalette is null', () {
      final colorScheme = getColorScheme(corePalette: null, isDark: false);

      expect(colorScheme.brightness, Brightness.light);
      expect(colorScheme.primary, isNotNull);
    });

    test('returns a dark color scheme when isDark is true and corePalette is null', () {
      final colorScheme = getColorScheme(corePalette: null, isDark: true);

      expect(colorScheme.brightness, Brightness.dark);
      expect(colorScheme.primary, isNotNull);
    });

    test('returns a light color scheme with custom colors when corePalette is provided', () {
      final corePalette = CorePalette.of(Colors.blue.value);
      final colorScheme = getColorScheme(corePalette: corePalette, isDark: false);

      expect(colorScheme.brightness, Brightness.light);
      expect(colorScheme.primary, isNotNull);
      expect(colorScheme.primary, equals(Color(corePalette.primary.get(40))));
    });

    test('returns a dark color scheme with custom colors when corePalette is provided', () {
      final corePalette = CorePalette.of(Colors.blue.value);
      final colorScheme = getColorScheme(corePalette: corePalette, isDark: true);

      expect(colorScheme.brightness, Brightness.dark);
      expect(colorScheme.primary, isNotNull);
      expect(colorScheme.primary, equals(Color(corePalette.primary.get(40))));
    });
  });
}