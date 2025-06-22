import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_bottom_nav_bar.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MenuBloc _menuBloc;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _menuBloc = context.read<MenuBloc>();
    
    // Load initial data
    _loadInitialData();
  }

  void _loadInitialData() {
    // Replace 'default-place-id' with actual place ID from your app's state
    const placeId = 'default-place-id';
    
    // Load supported locales
    _menuBloc.add(LoadSupportedLocalesEvent(placeId));
    
    // Load initial menu items
    _onCategorySelected(MenuCategory.values.first);
  }

  void _onCategorySelected(MenuCategory category) {
    setState(() {
      _currentIndex = category.index;
    });
    
    // Replace 'default-place-id' with actual place ID from your app's state
    const placeId = 'default-place-id';
    
    _menuBloc.add(LoadMenuEvent(
      placeId: placeId,
      category: category.toString().split('.').last,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceMate CMS'),
        actions: [
          // Add any app bar actions here (e.g., settings, search, etc.)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _menuBloc.add(const RefreshMenuEvent()),
          ),
        ],
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return MenuGrid(
            items: state.items,
            isLoading: state.status == MenuStatus.loading,
            errorMessage: state.errorMessage,
          );
        },
      ),
      bottomNavigationBar: MenuBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _onCategorySelected(MenuCategory.values[index]);
        },
      ),
    );
  }
}
