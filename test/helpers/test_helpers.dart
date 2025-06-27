import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

// Mock classes for testing
class MockBuildContext extends Mock implements BuildContext {}

class MockThemeData extends Mock implements ThemeData {
  @override
  ColorScheme get colorScheme => const ColorScheme.light();
  
  @override
  TextTheme get textTheme => const TextTheme();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => 'MockThemeData';
}

// Helper functions for testing
void setupScreenUtils() {
  // Mock ScreenUtils if needed
}

void setupImageUtils() {
  // Mock ImageUtils if needed
}

// Mock menu item for testing
MenuItemEntity createMockMenuItem({
  String? id,
  String? title,
  String? icon,
  int? order,
  bool? isVisible,
  bool? isAvailable,
  int? badgeCount,
}) {
  return MenuItemEntity(
    id: int.tryParse(id ?? '1') ?? 1,
    label: title ?? 'Test Item',
    icon: icon,
    order: order ?? 0,
    isVisible: isVisible ?? true,
    isAvailable: isAvailable ?? true,
    badgeCount: badgeCount,
  );
}

// Mock text styles for testing
TextTheme get mockTextTheme {
  return const TextTheme(
    displayLarge: TextStyle(fontSize: 96.0, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w400),
    headlineMedium: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );
}

// Mock theme data for testing
ThemeData mockThemeData({Brightness brightness = Brightness.light}) {
  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
    ),
    textTheme: mockTextTheme,
    useMaterial3: true,
  );
}
