import 'package:flutter/material.dart';
import 'package:spacemate/core/theme/app_colors.dart';
import 'package:spacemate/core/theme/app_text_styles.dart';
import 'package:spacemate/core/utils/screen_utils.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/presentation/widgets/cached_menu_image.dart';

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
  final bool showBadge;
  final bool showTitle;

  const MenuGridItem({
    Key? key,
    required this.item,
    this.onTap,
    this.isSelected = false,
    this.width,
    this.height,
    this.iconSize = 24.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.selectedColor,
    this.showBadge = true,
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bgColor = backgroundColor ?? colorScheme.surface;
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
            elevation: isSelected ? 2.0 : 0.5,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image/Icon Container
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background shape
                        Container(
                          width: itemWidth * 0.6,
                          height: itemWidth * 0.6,
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? selectedBgColor.withOpacity(0.2) 
                                : colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        
                        // Image or Icon
                        item.imageUrl?.isNotEmpty == true
                            ? CachedMenuImage(
                                imageUrl: item.imageUrl!,
                                placeholderIcon: item.icon,
                                width: itemWidth * 0.4,
                                height: itemWidth * 0.4,
                                fit: BoxFit.contain,
                                color: icoColor,
                              )
                            : Icon(
                                _getIconData(item.icon) ?? Icons.category,
                                size: iconSize,
                                color: icoColor,
                              ),
                        
                        // Badge
                        if (showBadge && item.badgeCount > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.error,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                item.badgeCount > 9 ? '9+' : '${item.badgeCount}',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onError,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 8.0),
                    
                    // Title
                    if (showTitle)
                      Flexible(
                        child: Text(
                          item.title,
                          style: textTheme.bodyMedium?.copyWith(
                            color: txtColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  IconData? _getIconData(String iconName) {
    // This is a simplified version - you might want to expand this
    // based on your icon naming convention
    switch (iconName.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'settings':
        return Icons.settings;
      case 'person':
        return Icons.person;
      case 'notifications':
        return Icons.notifications;
      case 'menu':
        return Icons.menu;
      case 'search':
        return Icons.search;
      default:
        return Icons.category;
    }
  }
}
