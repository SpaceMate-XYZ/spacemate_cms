import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/core/theme/app_colors.dart';
import 'package:spacemate/core/theme/app_text_styles.dart';
import 'package:spacemate/core/utils/screen_utils.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid_item.dart';

class MenuGrid extends StatelessWidget {
  final List<MenuItemEntity> items;
  final bool isLoading;
  final String? errorMessage;
  final bool showTitle;
  final int? maxCrossAxisExtent;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final String? emptyMessage;

  const MenuGrid({
    Key? key,
    required this.items,
    this.isLoading = false,
    this.errorMessage,
    this.showTitle = true,
    this.maxCrossAxisExtent,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.padding,
    this.physics,
    this.controller,
    this.emptyMessage = 'No items found',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState(context);
    }

    if (errorMessage != null) {
      return _buildErrorState(context, errorMessage!);
    }

    if (items.isEmpty) {
      return _buildEmptyState(context, emptyMessage!);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = ScreenUtils.getScreenSize(context);

        final crossAxisCount = maxCrossAxisExtent != null
            ? (constraints.maxWidth / maxCrossAxisExtent!).floor().clamp(1, 6)
            : _calculateCrossAxisCount(constraints.maxWidth);

        final availableWidth = constraints.maxWidth -
            (crossAxisSpacing * (crossAxisCount - 1)) -
            (padding?.horizontal ?? 0);
        final itemWidth = availableWidth / crossAxisCount;

        return Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: GridView.builder(
            controller: controller,
            physics: physics ?? const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return MenuGridItem(
                item: item,
                onTap: () => _onItemTapped(context, item),
                showTitle: showTitle,
                width: itemWidth,
                height: itemWidth * 1.2,
              );
            },
          ),
        );
      },
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 700) return 4;
    if (width > 550) return 3;
    if (width > 400) return 2;
    return 2;
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.0,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Oops!',
              style: AppTextStyles.headlineSmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: () => context.read<MenuBloc>().add(RefreshMenuEvent()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48.0,
              color: colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, MenuItemEntity item) {
    debugPrint('Menu item tapped: ${item.label} (${item.id})');
  }
}
