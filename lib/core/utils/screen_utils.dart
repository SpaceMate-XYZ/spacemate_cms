import 'package:flutter/material.dart';

/// A utility class for handling screen size and responsive design
class ScreenUtils {
  // Private constructor to prevent instantiation
  ScreenUtils._();

  /// Get the current screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Get the screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get the screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get the screen orientation
  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Check if the screen is in portrait mode
  static bool isPortrait(BuildContext context) {
    return getOrientation(context) == Orientation.portrait;
  }

  /// Check if the screen is in landscape mode
  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }

  /// Get the screen size category (mobile, tablet, desktop)
  static ScreenSizeCategory getScreenSizeCategory(BuildContext context) {
    final width = getScreenWidth(context);
    
    if (width > 1200) {
      return ScreenSizeCategory.desktop;
    } else if (width > 600) {
      return ScreenSizeCategory.tablet;
    } else {
      return ScreenSizeCategory.mobile;
    }
  }

  /// Check if the screen is mobile size
  static bool isMobile(BuildContext context) {
    return getScreenSizeCategory(context) == ScreenSizeCategory.mobile;
  }

  /// Check if the screen is tablet size
  static bool isTablet(BuildContext context) {
    return getScreenSizeCategory(context) == ScreenSizeCategory.tablet;
  }

  /// Check if the screen is desktop size
  static bool isDesktop(BuildContext context) {
    return getScreenSizeCategory(context) == ScreenSizeCategory.desktop;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenSize = getScreenSizeCategory(context);
    
    return switch (screenSize) {
      ScreenSizeCategory.mobile => const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ScreenSizeCategory.tablet => const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      ScreenSizeCategory.desktop => const EdgeInsets.symmetric(horizontal: 64.0, vertical: 24.0),
    };
  }

  /// Get responsive text scale factor based on screen size
  static double getTextScaleFactor(BuildContext context) {
    final width = getScreenWidth(context);
    
    if (width > 1200) return 1.2;    // Desktop
    if (width > 600) return 1.1;      // Tablet
    return 1.0;                       // Mobile
  }

  /// Get responsive icon size based on screen size
  static double getIconSize(BuildContext context, {double? small, double? medium, double? large}) {
    final screenSize = getScreenSizeCategory(context);
    
    return switch (screenSize) {
      ScreenSizeCategory.mobile => small ?? 24.0,
      ScreenSizeCategory.tablet => medium ?? 28.0,
      ScreenSizeCategory.desktop => large ?? 32.0,
    };
  }

  /// Get responsive border radius based on screen size
  static BorderRadius getBorderRadius(BuildContext context, {
    double? small,
    double? medium,
    double? large,
  }) {
    final screenSize = getScreenSizeCategory(context);
    
    final radius = switch (screenSize) {
      ScreenSizeCategory.mobile => small ?? 8.0,
      ScreenSizeCategory.tablet => medium ?? 12.0,
      ScreenSizeCategory.desktop => large ?? 16.0,
    };
    
    return BorderRadius.circular(radius);
  }

  /// Get responsive elevation based on screen size
  static double getElevation(BuildContext context, {
    double? small,
    double? medium,
    double? large,
  }) {
    final screenSize = getScreenSizeCategory(context);
    
    return switch (screenSize) {
      ScreenSizeCategory.mobile => small ?? 2.0,
      ScreenSizeCategory.tablet => medium ?? 3.0,
      ScreenSizeCategory.desktop => large ?? 4.0,
    };
  }
}

/// Enum representing different screen size categories
enum ScreenSizeCategory {
  mobile,
  tablet,
  desktop,
}
