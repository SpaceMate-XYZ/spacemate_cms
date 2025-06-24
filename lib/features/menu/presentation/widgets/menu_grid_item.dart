

import 'package:flutter/material.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/core/utils/icon_utils.dart';

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
  final int? badgeCount; // New property for badge count

  const MenuGridItem({
    super.key,
    required this.item,
    this.onTap,
    this.isSelected = false,
    this.width,
    this.height,
    this.iconSize = 28.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.selectedColor,
    this.showTitle = true,
    this.badgeCount, // Initialize badgeCount
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bgColor = backgroundColor ?? colorScheme.surfaceContainerHighest; // Use surfaceContainerHighest for inactive
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
            elevation: 16.0, // Increase elevation for more visible shadow
            shadowColor: Colors.black.withOpacity(0.8), // Increase shadow opacity
            borderRadius: BorderRadius.circular(borderRadius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: item.isAvailable ? onTap : null,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Opacity(
                opacity: item.isAvailable ? 1.0 : 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              IconUtils.getIconData(item.icon),
                              size: iconSize,
                              color: icoColor,
                            ),
                            if (showTitle) ...[
                              const SizedBox(height: 8),
                              Flexible(
                                child: Text(
                                  item.label,
                                  style: textTheme.bodyMedium?.copyWith(
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
                      if (item.badgeCount != null) ...[
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: colorScheme.error,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              item.badgeCount.toString(),
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onError,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
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

  // Map icon names from API to Material Icons using IconUtils
  IconData _getIconForItem(MenuItemEntity item) {
    return IconUtils.getIconData(item.icon);
  }
}
