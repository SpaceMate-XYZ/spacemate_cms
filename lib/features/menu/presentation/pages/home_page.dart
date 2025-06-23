import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/core/theme/app_theme.dart';
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/pages/access_page.dart';
import 'package:spacemate/features/menu/presentation/pages/discover_page.dart';
import 'package:spacemate/features/menu/presentation/pages/facilities_page.dart';
import 'package:spacemate/features/menu/presentation/pages/transport_page.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static void loadData(BuildContext context, {String? slug}) {
    context.read<MenuBloc>().add(
          LoadMenuEvent(
            slug: slug ?? MenuCategory.home.name,
            forceRefresh: true,
          ),
        );
  }
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
    // Load initial data
    HomePage.loadData(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    // Load data for the new page if needed
    final category = MenuCategory.values[index];
    HomePage.loadData(context, slug: category.name);
  }

  void _onItemTapped(int index) {
    if (_currentPageIndex != index) {
      setState(() {
        _currentPageIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MenuCategory.values[_currentPageIndex].displayName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final category = MenuCategory.values[_currentPageIndex];
              HomePage.loadData(context, slug: category.name);
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          _CategoryPage(category: MenuCategory.home),
          TransportPage(),
          AccessPage(),
          FacilitiesPage(),
          DiscoverPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: MenuCategory.values.map((category) {
          return NavigationDestination(
            icon: Icon(_getIconForCategory(category)),
            label: category.displayName,
          );
        }).toList(),
      ),
    );
  }
  
  static IconData _getIconForCategory(MenuCategory category) {
    switch (category) {
      case MenuCategory.home:
        return Icons.home_outlined;
      case MenuCategory.transport:
        return Icons.directions_car_outlined;
      case MenuCategory.access:
        return Icons.fingerprint_outlined;
      case MenuCategory.facilities:
        return Icons.apartment_outlined;
      case MenuCategory.discover:
        return Icons.explore_outlined;
    }
  }
}

class _CategoryPage extends StatelessWidget {
  final MenuCategory category;
  
  const _CategoryPage({required this.category});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return MenuGrid(
          items: state.items,
          isLoading: state.status == MenuStatus.loading,
          errorMessage: state.errorMessage,
        );
      },
    );
  }
}
