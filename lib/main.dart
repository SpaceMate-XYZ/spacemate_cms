import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // Added import
import 'package:spacemate/core/di/injection_container.dart' as di;
import 'package:spacemate/core/theme/app_theme.dart';
import 'package:spacemate/core/theme/theme_service.dart';
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize dependency injection, passing the Strapi URL
  await di.init(baseUrl: dotenv.env['STRAPI_BASE_URL']!);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider<ThemeService>(
      create: (context) => di.sl<ThemeService>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CarouselBloc>(
          create: (context) => di.sl<CarouselBloc>(),
        ),
        BlocProvider<MenuBloc>(
          create: (context) => di.sl<MenuBloc>()
            ..add(LoadMenuEvent(
              slug: MenuCategory.home.name,
              forceRefresh: false,
            )),
        ),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          final themeService = context.watch<ThemeService>();
          return MaterialApp.router(
            title: 'Spacemate',
            theme: AppTheme.lightTheme(lightDynamic),
            darkTheme: AppTheme.darkTheme(darkDynamic),
            themeMode: themeService.themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}

