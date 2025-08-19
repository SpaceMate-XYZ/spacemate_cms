import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spacemate/core/di/injection_container.dart';
import 'package:spacemate/core/config/app_config.dart';
import 'package:spacemate/core/services/download_service.dart';
import 'package:spacemate/core/theme/app_theme.dart';
import 'package:spacemate/core/theme/theme_service.dart';
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/features/asset_management/di/asset_injection.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize FFI for desktop, NOT web
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
       defaultTargetPlatform == TargetPlatform.linux ||
       defaultTargetPlatform == TargetPlatform.macOS)) {
    sqflite_ffi.sqfliteFfiInit();
    sqflite_ffi.databaseFactory = sqflite_ffi.databaseFactoryFfi;
  }

  // Initialize app configuration
  await AppConfig.init();

  // Initialize dependency injection
  await init(baseUrl: AppConfig.mainStrapiBaseUrl);
  
  // Initialize asset management
  await initAssetDependencies(sl);
  
  // Initialize download service
  await DownloadService.initialize();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set up error handling for FlutterDownloader (skip during tests to avoid interfering with test harness)
  if (!const bool.fromEnvironment('FLUTTER_TEST')) {
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      // Preserve any previous handler (test harness/framework) by calling it first.
      try {
        previousOnError?.call(details);
      } catch (_) {}
      FlutterError.presentError(details);
      // TODO: Log error to crash reporting service
      debugPrint('Flutter error: ${details.exception}');
    };
  }

  // Run the app with error boundaries
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
            ..add(LoadMenuGridsEvent(placeId: MenuCategory.home.name, forceRefresh: false)),
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

