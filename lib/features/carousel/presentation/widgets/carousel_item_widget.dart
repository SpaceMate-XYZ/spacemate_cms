import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemate/features/carousel/domain/entities/carousel_item_entity.dart';

class CarouselItemWidget extends StatelessWidget {
  final CarouselItemEntity item;
  final BorderRadius? borderRadius;
  final BoxFit? fit;
  final bool showTitle;
  final bool showDescription;
  final bool showActionButton;

  const CarouselItemWidget({
    super.key,
    required this.item,
    this.borderRadius,
    this.fit,
    this.showTitle = true,
    this.showDescription = true,
    this.showActionButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderRadius = this.borderRadius ?? BorderRadius.circular(12.0);

    return GestureDetector(
      onTap: item.actionRoute != null
          ? () => context.go(item.actionRoute!)
          : null,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                item.imageUrl,
                fit: fit ?? BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Positioned(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTitle && item.title.isNotEmpty)
                    Text(
                      item.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (showDescription && item.description?.isNotEmpty == true) ...{
                    const SizedBox(height: 8.0),
                    Text(
                      item.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  },
                  if (showActionButton && item.actionText?.isNotEmpty == true) ...{
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: item.actionRoute != null
                            ? () => context.go(item.actionRoute!)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(item.actionText!),
                      ),
                    ),
                  },
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
