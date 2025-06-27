import 'package:flutter/material.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

// Create a test menu item
MenuItemEntity createTestMenuItem({
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
