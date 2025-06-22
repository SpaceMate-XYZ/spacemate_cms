import 'package:flutter/material.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';

class MenuBottomNavBar extends StatelessWidget {
  const MenuBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0, // This will be managed by the state
      onTap: (index) {
        // Navigation logic will be added later
      },
      items: MenuCategory.values.map((category) {
        return BottomNavigationBarItem(
          icon: Icon(_getIconForCategory(category)),
          label: category.displayName,
        );
      }).toList(),
    );
  }

  IconData _getIconForCategory(MenuCategory category) {
    switch (category) {
      case MenuCategory.home:
        return Icons.home;
      case MenuCategory.transport:
        return Icons.directions_car;
      case MenuCategory.access:
        return Icons.fingerprint;
      case MenuCategory.facilities:
        return Icons.apartment;
      case MenuCategory.discover:
        return Icons.explore;
    }
  }
}
