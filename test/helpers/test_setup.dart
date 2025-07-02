import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemate/core/di/injection_container.dart' as di;
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/core/theme/theme_service.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_event.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_state.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_state.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/onboarding_state.dart';

class MockDioClient extends Mock implements DioClient {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockThemeService extends Mock implements ThemeService {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}
class MockCarouselBloc extends MockBloc<CarouselEvent, CarouselState> implements CarouselBloc {}
class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState> implements OnboardingBloc {}
class MockFeatureOnboardingCubit extends MockCubit<FeatureOnboardingState> implements FeatureOnboardingCubit {}

class TestSetup {
  static Future<void> initializeTestDI() async {
    // Reset GetIt instance
    await GetIt.instance.reset();
    
    // Register mocks for external dependencies
    GetIt.instance.registerLazySingleton<DioClient>(() => MockDioClient());
    GetIt.instance.registerLazySingleton<NetworkInfo>(() => MockNetworkInfo());
    GetIt.instance.registerLazySingleton<ThemeService>(() => MockThemeService());
    GetIt.instance.registerLazySingleton<SharedPreferences>(() => MockSharedPreferences());
    
    // Register mock BLoCs
    GetIt.instance.registerFactory<MenuBloc>(() => MockMenuBloc());
    GetIt.instance.registerFactory<CarouselBloc>(() => MockCarouselBloc());
    GetIt.instance.registerFactory<OnboardingBloc>(() => MockOnboardingBloc());
    GetIt.instance.registerFactory<FeatureOnboardingCubit>(() => MockFeatureOnboardingCubit());
  }

  static Widget createTestApp({
    required Widget child,
    MenuBloc? menuBloc,
    CarouselBloc? carouselBloc,
    OnboardingBloc? onboardingBloc,
    FeatureOnboardingCubit? featureOnboardingCubit,
  }) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          if (menuBloc != null)
            BlocProvider<MenuBloc>.value(value: menuBloc),
          if (carouselBloc != null)
            BlocProvider<CarouselBloc>.value(value: carouselBloc),
          if (onboardingBloc != null)
            BlocProvider<OnboardingBloc>.value(value: onboardingBloc),
          if (featureOnboardingCubit != null)
            BlocProvider<FeatureOnboardingCubit>.value(value: featureOnboardingCubit),
        ],
        child: child,
      ),
    );
  }

  static void tearDown() {
    GetIt.instance.reset();
  }
} 