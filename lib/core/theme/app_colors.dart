import 'package:flutter/material.dart';

/// A utility class that provides consistent colors for the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Brand colors - Light Theme
  static const Color primary = Color(0xFF1A237E); // Dark Blue from screenshots
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);

  // Light Theme specific colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color onSurfaceLight = Color(0xFF1F1F1F);
  static const Color onBackgroundLight = Color(0xFF1F1F1F);

  // Dark Theme specific colors
  static const Color surfaceDark = Color(0xFF121212);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);

  // Additional colors
  static const Color primaryLight = Color(0xFF9E47FF);
  static const Color primaryDark = Color(0xFF0400BA);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A895);
  
  // Neutral colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  
  // Surface container colors
  static const Color surfaceContainerHighest = Color(0xFFE0E0E0);
  static const Color onSurfaceVariant = Color(0xFF757575);
  static const Color outline = Color(0xFF757575);
  static const Color outlineVariant = Color(0xFFBDBDBD);
  static const Color transparent = Color(0x00000000);
  
  // Gray scale
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  
  static const Color warning = Color(0xFFFFA000);
  static const Color warningLight = Color(0xFFFFC107);
  static const Color warningDark = Color(0xFFFF8F00);
  
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  
  static const Color danger = Color(0xFFF44336);
  static const Color dangerLight = Color(0xFFEF5350);
  static const Color dangerDark = Color(0xFFD32F2F);

  // Social media colors
  static const Color facebook = Color(0xFF3B5998);
  static const Color google = Color(0xFFDB4437);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color linkedin = Color(0xFF0077B5);
  static const Color instagram = Color(0xFFE4405F);
  static const Color pinterest = Color(0xFFBD081C);
  static const Color youtube = Color(0xFFCD201F);
  static const Color whatsapp = Color(0xFF25D366);

  // Gradients
  static const List<Color> primaryGradient = [
    primary,
    primaryVariant,
  ];

  static const List<Color> secondaryGradient = [
    secondary,
    secondaryVariant,
  ];

  static const List<Color> successGradient = [
    success,
    successDark,
  ];

  static const List<Color> warningGradient = [
    warning,
    warningDark,
  ];

  static const List<Color> dangerGradient = [
    danger,
    dangerDark,
  ];

  // Get color based on brightness
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate the perceptive luminance (aka luma) - human eye favors green color... 
    final double luma = (0.299 * backgroundColor.red + 
                         0.587 * backgroundColor.green + 
                         0.114 * backgroundColor.blue) / 255;

    // Return black for bright colors, white for dark colors
    return luma > 0.5 ? Colors.black : Colors.white;
  }

  // Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'Opacity must be between 0.0 and 1.0');
    return color.withOpacity(opacity);
  }

  // Get color from hex string
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Convert color to hex string
  static String toHex(Color color, {bool leadingHashSign = true}) => 
      '${leadingHashSign ? '#' : ''}'
      '${color.alpha.toRadixString(16).padLeft(2, '0')}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}';

  // Get material color from color
  static MaterialColor createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    
    return MaterialColor(color.value, swatch);
  }
}

// Extension to easily apply color properties to widgets
extension ColorExtension on Color {
  // Get a slightly darker color
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');
    
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    
    return hslDark.toColor();
  }
  
  // Get a slightly lighter color
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');
    
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    
    return hslLight.toColor();
  }
  
  // Get a color with adjusted opacity
  Color withAlphaValue(int a) {
    return withAlpha(a.clamp(0, 255));
  }
  
  // Get a color with adjusted opacity (0.0 to 1.0)
  Color withOpacityValue(double opacity) {
    return withOpacity(opacity.clamp(0.0, 1.0));
  }
  
  // Get a color that contrasts well with this color
  Color get contrastColor {
    // Calculate the perceptive luminance (aka luma) - human eye favors green color... 
    final double luma = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;

    // Return black for bright colors, white for dark colors
    return luma > 0.5 ? Colors.black : Colors.white;
  }
}
