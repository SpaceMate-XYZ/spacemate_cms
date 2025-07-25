import 'package:flutter/material.dart';
import 'package:spacemate/core/theme/theme_toggle.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';

class MenuBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MenuBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ThemeToggleButton(), // Theme toggle button
        BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.grey[300], // Light gray background
          selectedItemColor: Theme.of(context).colorScheme.primary, // Primary color for active button
          unselectedItemColor: Colors.grey[600], // Dark gray for inactive buttons
          currentIndex: currentIndex,
          onTap: onTap,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), // Ensure selected label color
          unselectedLabelStyle: TextStyle(color: Colors.grey[600]), // Ensure unselected label color
          items: MenuCategory.values.map((category) {
            return BottomNavigationBarItem(
              icon: Icon(_getIconForCategory(category)),
              label: category.displayName,
            );
          }).toList(),
        ),
      ],
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
