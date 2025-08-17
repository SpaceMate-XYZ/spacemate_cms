import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/domain/entities/screen_entity.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid.dart';

class TransportPage extends StatelessWidget {
  const TransportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger load event if not already loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuBloc>().add(LoadMenuGridsEvent(placeId: MenuCategory.transport.name, forceRefresh: false));
    });

    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        if (state.status == MenuStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } 
        
        if (state.status == MenuStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.errorMessage ?? "Unknown error"}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<MenuBloc>().add(
                        LoadMenuEvent(
                          slug: MenuCategory.transport.name,
                          forceRefresh: true,
                        ),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Prefer screen-level grids when available
        final screen = state.screens.isNotEmpty
            ? state.screens.firstWhere(
                (s) => s.slug == MenuCategory.transport.name,
                orElse: () => state.screens.first,
              )
            : const ScreenEntity(id: 0, name: '', slug: '', title: '', menuGrid: []);

        final itemsToShow = screen.menuGrid.isNotEmpty ? screen.menuGrid : state.items;

        // Default to showing the menu grid
        return MenuGrid(
          items: itemsToShow,
          isLoading: state.status == MenuStatus.loading,
          errorMessage: state.errorMessage,
          category: MenuCategory.transport.name,
        );
      },
    );
  }

  static void loadData(BuildContext context) {
    context.read<MenuBloc>().add(LoadMenuGridsEvent(placeId: MenuCategory.transport.name, forceRefresh: true));
   }
 }
