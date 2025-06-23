import 'package:flutter/material.dart';
import 'package:spacemate/core/utils/icon_utils.dart';
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
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bgColor = backgroundColor ?? colorScheme.surfaceVariant.withOpacity(0.3);
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
                        IconUtils.getIconData(item.icon) ?? Icons.help_outline,
                        size: iconSize,
                        color: icoColor,
                      ),
                      if (showTitle) ...[
                        const SizedBox(height: 8),
                        Text(
                          item.label,
                          style: textTheme.bodyLarge?.copyWith(
                            color: txtColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
}
