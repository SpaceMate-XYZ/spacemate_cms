import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';

// Mock for ScreenUtils
class MockScreenUtils {
  static String getScreenSizeCategory(BuildContext context) => 'mobile';
}

// Mock for ScreenSizeCategory
enum ScreenSizeCategory { mobile, tablet, desktop }

// Mock for ImageUtils to prevent actual network calls
class MockImageUtils {
  static Future<String> getImageUrl(String path) async => 'https://example.com/image.png';
  
  static Widget cachedImage({
    required String imageUrl,
    required String placeholderIcon,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? color,
  }) {
    return MockCachedMenuImage(
      imageUrl: imageUrl,
      placeholderIcon: placeholderIcon,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}

// Extension to mock static methods
extension MockImageUtilsExtension on MockImageUtils {
  static void setupMocks() {
    // This is where we would set up any method channels or other mocks
    // For now, we'll just ensure our mock implementation is used
  }
}

// Helper function to set up mocks
void setupTestMocks() {
  // Override the default image loading behavior for tests
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  debugPrint('Test mocks initialized');
}

// Create a test app with Material and other required providers
Widget createTestApp(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: Scaffold(
      body: Center(
        child: child,
      ),
    ),
  );
}

// Mock CachedMenuImage to avoid actual network calls
class MockCachedMenuImage extends StatelessWidget {
  final String imageUrl;
  final String placeholderIcon;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const MockCachedMenuImage({
    super.key,
    required this.imageUrl,
    required this.placeholderIcon,
    this.width,
    this.height,
    this.fit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.image, color: color),
    );
  }
}

// Mock menu item for testing
MenuItemEntity createMockMenuItem({
  String? id,
  String? title,
  String? icon,
  MenuCategory? category,
  String? route,
  bool? isActive,
  int? order,
  int? badgeCount,
  List<String>? requiredPermissions,
  String? analyticsId,
  String? imageUrl,
}) {
  return MenuItemEntity(
    id: id ?? '1',
    title: title ?? 'Test Item',
    icon: icon ?? 'home',
    category: category ?? MenuCategory.transport,
    route: route ?? '/test',
    isActive: isActive ?? true,
    order: order,
    badgeCount: badgeCount ?? 0,
    requiredPermissions: requiredPermissions ?? const [],
    analyticsId: analyticsId ?? 'test_item',
    imageUrl: imageUrl,
  );
}
