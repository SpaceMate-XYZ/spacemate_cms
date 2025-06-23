import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/core/extensions/string_extensions.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid.dart';

class MenuScreen extends StatefulWidget {
  final String slug;
  final String? appBarTitle;
  final bool showAppBar;
  final bool enablePullToRefresh;

  const MenuScreen({
    super.key,
    required this.slug,
    this.appBarTitle,
    this.showAppBar = true,
    this.enablePullToRefresh = true,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // Initial data load is dispatched when the widget is first built
    // if the BLoC state is initial or for a different slug.
    final currentSlug = context.read<MenuBloc>().state.slug;
    if (context.read<MenuBloc>().state.status == MenuStatus.initial || currentSlug != widget.slug) {
      _fetchMenuItems();
    }
  }

  @override
  void didUpdateWidget(MenuScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.slug != oldWidget.slug) {
      _fetchMenuItems();
    }
  }

  @override
  bool get wantKeepAlive => true;

  String get effectiveSlug => widget.slug.isNotEmpty ? widget.slug : 'home';
  String get effectiveAppBarTitle =>
      widget.appBarTitle ?? (widget.slug.isEmpty ? 'Menu' : widget.slug.capitalize());

  Future<void> _fetchMenuItems({bool forceRefresh = false}) async {
    context.read<MenuBloc>().add(
          LoadMenuEvent(
            slug: effectiveSlug,
            forceRefresh: forceRefresh,
          ),
        );
  }

  Future<void> _onRefresh() async {
    await _fetchMenuItems(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(effectiveAppBarTitle),
              centerTitle: true,
              elevation: 0,
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
            )
          : null,
      body: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state.status == MenuStatus.failure && state.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Retry',
                      textColor: colorScheme.onError,
                      onPressed: () => _fetchMenuItems(),
                    ),
                  ),
                );
              }
            });
          }
        },
        builder: (context, state) {
          if (state.status == MenuStatus.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MenuStatus.failure && state.items.isEmpty) {
            return _buildErrorState(context, state.errorMessage!);
          }

          final Widget grid = MenuGrid(
            items: state.items,
            isLoading: state.status == MenuStatus.loading,
          );

          if (widget.enablePullToRefresh) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: grid,
            );
          }
          return grid;
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Menu',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () => _fetchMenuItems(),
            ),
          ],
        ),
      ),
    );
  }
}
