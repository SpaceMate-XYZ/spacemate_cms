import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacemate/core/utils/screen_utils.dart';

/// A utility class that provides consistent text styles for the app
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Font families
  static const String _primaryFontFamily = 'Roboto';
  static const String _secondaryFontFamily = 'Poppins';
  static const String _monospaceFontFamily = 'RobotoMono';

  // Text styles with Google Fonts
  static TextStyle? get displayLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle? get displayMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.15,
      );

  static TextStyle? get displaySmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      );

  static TextStyle? get headlineLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      );

  static TextStyle? get headlineMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.28,
      );

  static TextStyle? get headlineSmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      );

  static TextStyle? get titleLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
      );

  static TextStyle? get titleMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle? get titleSmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.42,
      );

  static TextStyle? get bodyLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      );

  static TextStyle? get bodyMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.42,
      );

  static TextStyle? get bodySmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  static TextStyle? get labelLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.42,
      );

  static TextStyle? get labelMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle? get labelSmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  // Custom text styles
  static TextStyle? get buttonLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.5,
      );

  static TextStyle? get buttonMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.42,
      );

  static TextStyle? get buttonSmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.33,
      );

  // App-specific text styles
  static TextStyle? get appBarTitle => GoogleFonts.getFont(
        _secondaryFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.2,
      );

  static TextStyle? get cardTitle => GoogleFonts.getFont(
        _secondaryFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.33,
      );

  static TextStyle? get cardSubtitle => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.42,
      );

  static TextStyle? get inputLabel => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle? get inputText => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      );

  static TextStyle? get inputHint => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.42,
        color: Colors.grey,
      );

  static TextStyle? get errorText => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: Colors.red,
      );

  // Helper methods for text themes
  static TextTheme getTextTheme([Brightness brightness = Brightness.light]) {
    final baseTextTheme = brightness == Brightness.light
        ? Typography.material2021().black
        : Typography.material2021().white;

    return GoogleFonts.robotoTextTheme(baseTextTheme).copyWith(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  // Get text style based on screen size
  static TextStyle? getResponsiveTextStyle(
    BuildContext context, {
    TextStyle? small,
    TextStyle? medium,
    TextStyle? large,
  }) {
    final screenSize = ScreenUtils.getScreenSizeCategory(context);
    
    return switch (screenSize) {
      ScreenSizeCategory.mobile => small ?? bodySmall,
      ScreenSizeCategory.tablet => medium ?? bodyMedium,
      ScreenSizeCategory.desktop => large ?? bodyLarge,
      _ => bodyMedium, // Default case for any unexpected values
    };
  }
}

/*
// Extension to easily apply text styles to Text widgets
extension TextExtension on Text {
  Text style(TextStyle? style, {bool inherit = true}) {
    return Text(
      data ?? '',
      style: style?.copyWith(
        color: inherit ? style.color : null,
        backgroundColor: inherit ? style.backgroundColor : null,
        fontSize: style?.fontSize,
        fontWeight: style?.fontWeight,
        fontStyle: style?.fontStyle,
        letterSpacing: style?.letterSpacing,
        wordSpacing: style?.wordSpacing,
        textBaseline: style?.textBaseline,
        height: style?.height,
        leadingDistribution: style?.leadingDistribution,
        locale: style?.locale,
        foreground: style?.foreground,
        background: style?.background,
        shadows: style?.shadows,
        fontFeatures: style?.fontFeatures,
        fontVariations: style?.fontVariations,
        decoration: style?.decoration,
        decorationColor: style?.decorationColor,
        decorationStyle: style?.decorationStyle,
        decorationThickness: style?.decorationThickness,
        debugLabel: style?.debugLabel,
        fontFamily: style?.fontFamily,
        fontFamilyFallback: style?.fontFamilyFallback,
        overflow: style?.overflow,
      ),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
*/
