import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/core/theme/app_colors.dart';
import 'package:spacemate/core/theme/app_text_styles.dart';
import 'package:spacemate/core/utils/screen_utils.dart';
import 'package:spacemate/core/extensions/string_extensions.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid.dart';

class MenuScreen extends StatefulWidget {
  final String? placeId;
  final String category;
  final bool showAppBar;
  final String? appBarTitle;
  final bool enablePullToRefresh;
  static const String defaultPlaceId = 'default_place_collection';

  const MenuScreen({
    Key? key,
    this.placeId,
    this.category = 'home',
    this.showAppBar = true,
    this.appBarTitle,
    this.enablePullToRefresh = true,
  }) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Initial fetch of menu items
    _fetchMenuItems();
  }

  @override
  void didUpdateWidget(MenuScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If placeId or category changed, fetch new data
    if (oldWidget.placeId != widget.placeId || oldWidget.category != widget.category) {
      _fetchMenuItems();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String get effectivePlaceId => widget.placeId ?? MenuScreen.defaultPlaceId;
  String get effectiveCategory => widget.category.isNotEmpty 
      ? widget.category 
      : 'home';
  String get effectiveAppBarTitle => widget.appBarTitle ?? 
      (widget.category.isEmpty ? 'Menu' : widget.category.capitalize());

  Future<void> _fetchMenuItems() async {
    context.read<MenuBloc>().add(
          LoadMenuEvent(
            placeId: effectivePlaceId,
            category: effectiveCategory,
            forceRefresh: false,
          ),
        );
  }

  Future<void> _onRefresh() async {
    context.read<MenuBloc>().add(
          LoadMenuEvent(
            placeId: effectivePlaceId,
            category: effectiveCategory,
            forceRefresh: true,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content = BlocConsumer<MenuBloc, MenuState>(
      listener: (context, state) {
        if (state.status == MenuStatus.failure && state.errorMessage != null) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Retry',
                textColor: colorScheme.onError,
                onPressed: _fetchMenuItems,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == MenuStatus.loading && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == MenuStatus.failure && state.errorMessage != null) {
          return _buildErrorState(context, state.errorMessage!);
        }

        final menuItems = state.items;
        final isLoading = state.status == MenuStatus.loading;

        if (menuItems.isEmpty && !isLoading) {
          return _buildEmptyState(context);
        }

        return MenuGrid(
          items: menuItems,
          isLoading: isLoading,
          errorMessage: state.errorMessage,
          controller: _scrollController,
        );
      },
    );

    // Wrap with RefreshIndicator if pull-to-refresh is enabled
    if (widget.enablePullToRefresh) {
      content = RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        child: content,
      );
    }

    // Apply safe area and scrolling
    content = CustomScrollView(
      controller: _scrollController,
      physics: widget.enablePullToRefresh
          ? const AlwaysScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      slivers: [
        if (widget.showAppBar) _buildAppBar(context),
        SliverFillRemaining(
          child: content,
        ),
      ],
    );

    return content;
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(
        widget.appBarTitle ?? widget.category,
        style: AppTextStyles.appBarTitle,
      ),
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
      centerTitle: false,
      titleSpacing: 20,
      toolbarHeight: kToolbarHeight + 8,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.0,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Something went wrong',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: AppTextStyles.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: _fetchMenuItems,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48.0,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16.0),
            Text(
              'No items found',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'There are no menu items available in this category.',
              style: AppTextStyles.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            OutlinedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Refresh'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
