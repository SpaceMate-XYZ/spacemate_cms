import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/core/di/injection_container.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_items.dart';
import 'package:spacemate/features/menu/domain/usecases/get_supported_locales.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/screens/menu_screen.dart';

class MenuPage extends StatelessWidget {
  final String? placeId;
  final String initialCategory;
  final String? appBarTitle;
  final bool showAppBar;
  final bool enablePullToRefresh;

  const MenuPage({
    Key? key,
    this.placeId,
    this.initialCategory = 'home',
    this.appBarTitle,
    this.showAppBar = true,
    this.enablePullToRefresh = true,
  }) : super(key: key);
  
  // Helper method to get the effective place ID
  String get effectivePlaceId => placeId ?? MenuScreen.defaultPlaceId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MenuBloc(
            getMenuItems: sl<GetMenuItems>(),
            getSupportedLocales: sl<GetSupportedLocales>(),
          )..add(
              LoadMenuEvent(
                placeId: effectivePlaceId,
                category: initialCategory,
              ),
            ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MenuScreen(
            placeId: placeId,
            category: initialCategory,
            appBarTitle: appBarTitle,
            showAppBar: showAppBar,
            enablePullToRefresh: enablePullToRefresh,
          );
        },
      ),
    );
  }
}
