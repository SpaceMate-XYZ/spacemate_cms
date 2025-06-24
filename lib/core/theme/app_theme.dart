import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color Schemes
  static ColorScheme _getDynamicColorScheme(ColorScheme? dynamicColorScheme, bool isDark) {
    final defaultLight = ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurfaceLight,
      onError: AppColors.onError,
    );

    final defaultDark = ColorScheme.dark(
      primary: Colors.grey.shade400, // Lighter gray for dark mode icons
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurfaceDark,
      onError: AppColors.onError,
    );

    final baseScheme = dynamicColorScheme ?? (isDark ? defaultDark : defaultLight);
    return baseScheme.copyWith(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: isDark ? Colors.grey.shade400 : AppColors.primary, // Use gray for dark mode, original primary for light mode
      secondary: AppColors.secondary,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onError: AppColors.onError,
    );
  }

  // Theme configuration
  static ThemeData getTheme({bool isDark = false, ColorScheme? dynamicColorScheme}) {
    final colors = _getDynamicColorScheme(dynamicColorScheme, isDark);
    final textTheme = _buildTextTheme(colors, isDark);
    
    // Create a base theme based on brightness
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
    
    // Apply our custom theme overrides
    return baseTheme.copyWith(
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      cardColor: colors.surface,
      dividerColor: colors.outline.withOpacity(0.5),
      disabledColor: colors.onSurface.withOpacity(0.38),
      
      // Text Theme with fallback
      textTheme: _buildTextThemeWithFallback(textTheme),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colors.primary, // Updated to use primary color
        foregroundColor: colors.onPrimary, // Ensure good contrast
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white, // Ensure good contrast against dark navy blue background
        ),
      ),
      
      // Card Theme - Using a compatible approach
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
        backgroundColor: colors.surfaceContainerHighest,
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
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colors, bool isDark) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.onSurfaceVariant,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colors.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
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

  // Build text theme with Google Fonts fallback
  static TextTheme _buildTextThemeWithFallback(TextTheme textTheme) {
    try {
      return GoogleFonts.poppinsTextTheme(textTheme);
    } catch (e) {
      // Fallback to system fonts if Google Fonts fails to load
      return textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(fontFamily: 'SF Pro Display'),
        displayMedium: textTheme.displayMedium?.copyWith(fontFamily: 'SF Pro Display'),
        displaySmall: textTheme.displaySmall?.copyWith(fontFamily: 'SF Pro Display'),
        headlineLarge: textTheme.headlineLarge?.copyWith(fontFamily: 'SF Pro Display'),
        headlineMedium: textTheme.headlineMedium?.copyWith(fontFamily: 'SF Pro Display'),
        headlineSmall: textTheme.headlineSmall?.copyWith(fontFamily: 'SF Pro Display'),
        titleLarge: textTheme.titleLarge?.copyWith(fontFamily: 'SF Pro Text'),
        titleMedium: textTheme.titleMedium?.copyWith(fontFamily: 'SF Pro Text'),
        titleSmall: textTheme.titleSmall?.copyWith(fontFamily: 'SF Pro Text'),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontFamily: 'SF Pro Text'),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontFamily: 'SF Pro Text'),
        bodySmall: textTheme.bodySmall?.copyWith(fontFamily: 'SF Pro Text'),
        labelLarge: textTheme.labelLarge?.copyWith(fontFamily: 'SF Pro Text'),
        labelMedium: textTheme.labelMedium?.copyWith(fontFamily: 'SF Pro Text'),
        labelSmall: textTheme.labelSmall?.copyWith(fontFamily: 'SF Pro Text'),
      );
    }
  }
  
  // Get text theme based on brightness
  static TextTheme _getTextTheme(bool isDark) {
    return _buildTextTheme(
      isDark ? _getDynamicColorScheme(null, true) : _getDynamicColorScheme(null, false),
      isDark,
    );
  }
  
  // Custom themes for specific parts of the app
  static ThemeData get lightTheme => getTheme(isDark: false);
  
  static ThemeData get darkTheme => getTheme(isDark: true);

  // Helper method to get the current theme based on context
  static ThemeData getThemeFromContext(BuildContext context, {bool? dark}) {
    final dynamicColorScheme = Theme.of(context).colorScheme;
    final isDark = dark ?? dynamicColorScheme.brightness == Brightness.dark;
    return getTheme(isDark: isDark, dynamicColorScheme: dynamicColorScheme);
  }
}
