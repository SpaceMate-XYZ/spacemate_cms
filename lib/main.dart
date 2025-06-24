import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spacemate/core/di/injection_container.dart' as di;
import 'package:spacemate/core/theme/app_theme.dart';
import 'package:spacemate/core/theme/theme_service.dart'; // Added import
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:dynamic_color/dynamic_color.dart'; // Added import

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

  // Theme service is now initialized in dependency injection

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
          return StreamBuilder<bool>(
            stream: di.sl<ThemeService>().isDarkMode,
            builder: (context, snapshot) {
              final isDark = snapshot.data ?? false;
              return MaterialApp.router(
                title: 'Spacemate',
                theme: AppTheme.getTheme(isDark: false, dynamicColorScheme: lightDynamic),
                darkTheme: AppTheme.getTheme(isDark: true, dynamicColorScheme: darkDynamic),
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}

