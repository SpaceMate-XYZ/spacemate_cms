import 'package:flutter/material.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

// Create a test menu item
MenuItemEntity createTestMenuItem({
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
    Key? key,
    required this.imageUrl,
    required this.placeholderIcon,
    this.width,
    this.height,
    this.fit,
    this.color,
  }) : super(key: key);

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
