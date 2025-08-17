import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/pages/access_page.dart';
import 'package:spacemate/features/menu/presentation/pages/discover_page.dart';
import 'package:spacemate/features/menu/presentation/pages/facilities_page.dart';
import 'package:spacemate/features/menu/presentation/pages/transport_page.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid.dart';
import 'package:spacemate/core/theme/theme_toggle.dart';
import 'package:spacemate/features/carousel/presentation/widgets/carousel_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static void loadData(BuildContext context, {String? slug}) {
    // Prefer requesting menu grids which contain screen-level metadata for the requested slug/place.
    context.read<MenuBloc>().add(LoadMenuGridsEvent(placeId: slug ?? MenuCategory.home.name, forceRefresh: true));
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
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          // Theme toggle button
          ThemeToggleButton(),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: 5,
        itemBuilder: (context, index) {
          Widget page;
          switch (index) {
            case 0:
              page = const _CategoryPage(category: MenuCategory.home);
              break;
            case 1:
              page = const TransportPage();
              break;
            case 2:
              page = const AccessPage();
              break;
            case 3:
              page = const FacilitiesPage();
              break;
            case 4:
              page = const DiscoverPage();
              break;
            default:
              page = const _CategoryPage(category: MenuCategory.home);
          }
          
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey(index),
              child: page,
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: MenuCategory.values.map((category) {
          return NavigationDestination(
            icon: Icon(
              _getIconForCategory(category),
              size: 28.0, // Increased icon size to match menu items
            ),
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
        if (category == MenuCategory.home) {
          return Column(
            children: [
              const CarouselWidget(),
              const SizedBox(height: 16),
              Expanded(
                child: MenuGrid(
                  items: (state.screens.isNotEmpty
                          ? (state.screens.firstWhere((s) => s.slug == MenuCategory.home.name, orElse: () => state.screens.first)).menuGrid
                          : state.items),
                  isLoading: state.status == MenuStatus.loading,
                  errorMessage: state.errorMessage,
                  category: category.name,
                ),
              ),
            ],
          );
        }
        
        // For other categories, just show the grid
        return MenuGrid(
          items: (state.screens.isNotEmpty
                  ? (state.screens.firstWhere((s) => s.slug == category.name, orElse: () => state.screens.first)).menuGrid
                  : state.items),
            isLoading: state.status == MenuStatus.loading,
            errorMessage: state.errorMessage,
            category: category.name,
          );
      },
    );
  }
}
