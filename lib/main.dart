import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spacemate/core/di/injection_container.dart' as di;
import 'package:spacemate/core/theme/app_theme.dart';
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final lightTheme = AppTheme.getTheme(
          seedColor: lightColorScheme?.primary ?? Colors.blue,
          brightness: Brightness.light,
        );
        
        final darkTheme = AppTheme.getTheme(
          seedColor: darkColorScheme?.primary ?? Colors.blue,
          brightness: Brightness.dark,
        );
        
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
          child: MaterialApp.router(
            title: 'Spacemate',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              // Ensure text contrast is good for accessibility
              final textTheme = Theme.of(context).textTheme;
              final colorScheme = Theme.of(context).colorScheme;
              
              return Theme(
                data: Theme.of(context).copyWith(
                  textTheme: textTheme.apply(
                    bodyColor: colorScheme.onSurface,
                    displayColor: colorScheme.onSurface,
                  ),
                ),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}

