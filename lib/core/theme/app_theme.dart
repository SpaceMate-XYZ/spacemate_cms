
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Unified getTheme method that handles both dynamic theming and fallback theming
  static ThemeData getTheme({
    Color? seedColor,
    Brightness? brightness,
    ColorScheme? colorScheme,
  }) {
    final isDark = brightness == Brightness.dark;
    final colors = colorScheme ?? _getColorScheme(seedColor, isDark);
    final textTheme = _buildTextTheme(colors, isDark);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.surface,
      dividerColor: colors.outline.withOpacity(0.5),
      disabledColor: colors.onSurface.withOpacity(0.38),
      
      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: colors.outline.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        color: colors.surface,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        hintStyle: TextStyle(color: colors.onSurfaceVariant.withOpacity(0.7)),
        errorStyle: TextStyle(color: colors.error),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceVariant,
        disabledColor: colors.onSurface.withOpacity(0.12),
        selectedColor: colors.primaryContainer,
        secondarySelectedColor: colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        secondaryLabelStyle: TextStyle(color: colors.onPrimary),
        brightness: brightness,
      ),
    );
  }
  
  static ColorScheme _getDefaultColorScheme(bool isDark) {
    return isDark 
        ? ColorScheme.dark(
            primary: Colors.blue.shade300,
            onPrimary: Colors.black,
            primaryContainer: Colors.blue.shade800,
            onPrimaryContainer: Colors.blue.shade100,
            secondary: Colors.teal.shade300,
            onSecondary: Colors.black,
            secondaryContainer: Colors.teal.shade800,
            onSecondaryContainer: Colors.teal.shade100,
            error: Colors.red.shade400,
            onError: Colors.black,
            errorContainer: Colors.red.shade900,
            onErrorContainer: Colors.red.shade100,
            background: Colors.grey.shade900,
            onBackground: Colors.white,
            surface: Colors.grey.shade800,
            onSurface: Colors.white,
            surfaceVariant: Colors.grey.shade700,
            onSurfaceVariant: Colors.grey.shade300,
            outline: Colors.grey.shade600,
            outlineVariant: Colors.grey.shade700,
          )
        : ColorScheme.light(
            primary: Colors.blue.shade700,
            onPrimary: Colors.white,
            primaryContainer: Colors.blue.shade100,
            onPrimaryContainer: Colors.blue.shade900,
            secondary: Colors.teal.shade700,
            onSecondary: Colors.white,
            secondaryContainer: Colors.teal.shade100,
            onSecondaryContainer: Colors.teal.shade900,
            error: Colors.red.shade700,
            onError: Colors.white,
            errorContainer: Colors.red.shade100,
            onErrorContainer: Colors.red.shade900,
            background: Colors.grey.shade50,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            surfaceVariant: Colors.grey.shade100,
            onSurfaceVariant: Colors.grey.shade800,
            outline: Colors.grey.shade400,
            outlineVariant: Colors.grey.shade300,
          );
  }
  
  static TextTheme _buildTextTheme(ColorScheme colors, bool isDark) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: colors.onBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: colors.onBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colors.onBackground,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.onSurfaceVariant,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colors.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.onBackground,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colors.onSurfaceVariant,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colors.onSurfaceVariant,
      ),
    );
  }

  // Get color scheme based on seed color and brightness
  static ColorScheme _getColorScheme(Color? seedColor, bool isDark) {
    if (seedColor != null) {
      // Create a dynamic color scheme from the seed color
      final dynamicColors = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      );
      return dynamicColors;
    }
    
    // Fallback to default color scheme if no seed color is provided
    return isDark 
        ? ColorScheme.dark(
            primary: Colors.blue.shade300,
            onPrimary: Colors.black,
            primaryContainer: Colors.blue.shade800,
            onPrimaryContainer: Colors.blue.shade100,
            secondary: Colors.teal.shade300,
            onSecondary: Colors.black,
            secondaryContainer: Colors.teal.shade800,
            onSecondaryContainer: Colors.teal.shade100,
            error: Colors.red.shade400,
            onError: Colors.black,
            errorContainer: Colors.red.shade900,
            onErrorContainer: Colors.red.shade100,
            background: Colors.grey.shade900,
            onBackground: Colors.white,
            surface: Colors.grey.shade800,
            onSurface: Colors.white,
            surfaceVariant: Colors.grey.shade700,
            onSurfaceVariant: Colors.grey.shade300,
            outline: Colors.grey.shade600,
            outlineVariant: Colors.grey.shade700,
          )
        : ColorScheme.light(
            primary: Colors.blue.shade700,
            onPrimary: Colors.white,
            primaryContainer: Colors.blue.shade100,
            onPrimaryContainer: Colors.blue.shade900,
            secondary: Colors.teal.shade700,
            onSecondary: Colors.white,
            secondaryContainer: Colors.teal.shade100,
            onSecondaryContainer: Colors.teal.shade900,
            error: Colors.red.shade700,
            onError: Colors.white,
            errorContainer: Colors.red.shade100,
            onErrorContainer: Colors.red.shade900,
            background: Colors.grey.shade50,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            surfaceVariant: Colors.grey.shade100,
            onSurfaceVariant: Colors.grey.shade800,
            outline: Colors.grey.shade400,
            outlineVariant: Colors.grey.shade300,
          );
  }
  
  // Get text theme based on brightness
  static TextTheme _getTextTheme(bool isDark) {
    return _buildTextTheme(
      _getColorScheme(null, isDark),
      isDark,
    );
  }
  
  // Custom themes for specific parts of the app
  static ThemeData get lightTheme => getTheme(brightness: Brightness.light);
  
  static ThemeData get darkTheme => getTheme(brightness: Brightness.dark);

  // Helper method to get the current theme based on context
  static ThemeData getThemeFromContext(BuildContext context, {bool? dark}) {
    final brightness = dark ?? Theme.of(context).brightness == Brightness.dark;
    return brightness ? darkTheme : lightTheme;
  }
}
