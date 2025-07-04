import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart'; // Added import
import 'package:spacemate/core/di/injection_container.dart';
import 'package:spacemate/core/config/app_config.dart';
import 'package:spacemate/core/theme/app_theme.dart';
import 'package:spacemate/core/theme/theme_service.dart';
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize FFI for desktop, NOT web
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
       defaultTargetPlatform == TargetPlatform.linux ||
       defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize app configuration
  await AppConfig.init();

  // Initialize dependency injection, passing the main Strapi URL from config
  await init(baseUrl: AppConfig.mainStrapiBaseUrl);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider<ThemeService>(
      create: (context) => sl<ThemeService>(),
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
          create: (context) => sl<CarouselBloc>(),
        ),
        BlocProvider<MenuBloc>(
          create: (context) => sl<MenuBloc>()
            ..add(LoadMenuEvent(
              slug: MenuCategory.home.name,
              forceRefresh: false,
            )),
        ),
        BlocProvider<OnboardingBloc>(
          create: (context) => sl<OnboardingBloc>(),
        ),
        BlocProvider<FeatureOnboardingCubit>(
          create: (context) => sl<FeatureOnboardingCubit>(),
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

