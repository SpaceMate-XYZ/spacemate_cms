

import 'package:flutter/material.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

class MenuGridItem extends StatelessWidget {
  final MenuItemEntity item;
  final VoidCallback? onTap;
  final bool isSelected;
  final double? width;
  final double? height;
  final double iconSize;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final Color? selectedColor;
  final bool showTitle;

  const MenuGridItem({
    super.key,
    required this.item,
    this.onTap,
    this.isSelected = false,
    this.width,
    this.height,
    this.iconSize = 32.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.selectedColor,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bgColor = backgroundColor ?? colorScheme.surfaceContainerHighest.withOpacity(0.3);
    final txtColor = textColor ?? colorScheme.onSurface;
    final icoColor = iconColor ?? colorScheme.primary;
    final selectedBgColor = selectedColor ?? colorScheme.primaryContainer;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = width ?? constraints.maxWidth;
        final itemHeight = height ?? itemWidth * 1.2;

        return SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: Material(
            color: isSelected ? selectedBgColor : bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            clipBehavior: Clip.antiAlias,
            elevation: isSelected ? 4.0 : 1.0,
            shadowColor: Colors.black.withOpacity(0.1),
            child: InkWell(
              onTap: item.isAvailable ? onTap : null,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Opacity(
                opacity: item.isAvailable ? 1.0 : 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconForItem(item) ?? Icons.help_outline,
                        size: iconSize,
                        color: icoColor,
                      ),
                      if (showTitle) ...[
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            item.label,
                            style: textTheme.bodyLarge?.copyWith(
                              color: txtColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Map icon names from API to Material Icons
  IconData? _getIconForItem(MenuItemEntity item) {
    if (item.icon == null) return Icons.help_outline;
    
    // Extract the icon name by removing 'MaterialSymbols.' prefix if it exists
    String iconName = item.icon!;
    if (iconName.startsWith('MaterialSymbols.')) {
      iconName = iconName.substring('MaterialSymbols.'.length);
    }
    
    // Convert to snake_case (Flutter Material Icons format)
    String iconKey = iconName;
    
    // Map to Material Icons
    switch (iconKey) {
      // Common icons
      case 'directions_car': return Icons.directions_car;
      case 'local_parking': return Icons.local_parking;
      case 'ev_station': return Icons.ev_station;
      case 'location_city': return Icons.location_city;
      case 'apartment': return Icons.apartment;
      case 'grid_on': return Icons.grid_on;
      case 'person_add': return Icons.person_add;
      case 'psychology_alt': return Icons.psychology_alt;
      case 'meeting_room': return Icons.meeting_room;
      case 'airport_shuttle': return Icons.airport_shuttle;
      case 'moped': return Icons.moped;
      case 'fastfood': return Icons.fastfood;
      case 'coffee_maker': return Icons.coffee_maker;
      case 'fitness_center': return Icons.fitness_center;
      case 'directions_run': return Icons.directions_run;
      case 'sports_esports': return Icons.sports_esports;
      case 'stethoscope': return Icons.medical_services;
      case 'psychology': return Icons.psychology;
      case 'spa': return Icons.spa;
      case 'shopping_basket': return Icons.shopping_basket;
      case 'event': return Icons.event;
      case 'mood': return Icons.mood;
      case 'elevator': return Icons.elevator;
      case 'print_connect': return Icons.print;
      case 'flex_wrap': return Icons.view_week;
      case 'diversity_1': return Icons.people;
      case 'local_taxi': return Icons.local_taxi;
      case 'check_in_out': return Icons.meeting_room;
      
      // Add more mappings as needed
      default: 
        debugPrint('No icon mapping found for: $iconKey');
        return Icons.help_outline;
    }
  }
}
