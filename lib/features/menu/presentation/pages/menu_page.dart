import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/core/di/injection_container.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_items.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/screens/menu_screen.dart';

class MenuPage extends StatelessWidget {
  final String slug;
  final String? appBarTitle;
  final bool showAppBar;
  final bool enablePullToRefresh;

  const MenuPage({
    Key? key,
    required this.slug,
    this.appBarTitle,
    this.showAppBar = true,
    this.enablePullToRefresh = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc(
        getMenuItems: sl<GetMenuItems>(),
      ),
      child: MenuScreen(
        slug: slug,
        appBarTitle: appBarTitle,
        showAppBar: showAppBar,
        enablePullToRefresh: enablePullToRefresh,
      ),
    );
  }
}
