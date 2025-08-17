import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Core
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/core/theme/theme_service.dart';

// Features - Carousel
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';

// Features - Menu
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';

// Features - Onboarding
import 'package:spacemate/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';

class MockDioClient extends Mock implements DioClient {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockThemeService extends Mock implements ThemeService {}

class MockMenuBloc extends Mock implements MenuBloc {
  @override
  MenuState get state => const MenuState();
}
class MockCarouselBloc extends Mock implements CarouselBloc {
  @override
  CarouselState get state => CarouselInitial();
}
class MockOnboardingBloc extends Mock implements OnboardingBloc {
  final _state = const OnboardingState.initial();
  
  @override
  OnboardingState get state => _state;
  
  @override
  Stream<OnboardingState> get stream => Stream.value(_state);
  
  @override
  bool get isClosed => false;
  
  @override
  void add(OnboardingEvent event) {}
  
  @override
  void emit(OnboardingState state) {}
  
  @override
  Future<void> close() async {}
  
  // Helper method to set the state for testing
  void setState(OnboardingState state) {
    when(() => this.state).thenReturn(state);
  }
}
class MockFeatureOnboardingCubit extends Mock implements FeatureOnboardingCubit {
  final _state = const FeatureOnboardingState.initial();
  
  @override
  FeatureOnboardingState get state => _state;
  
  @override
  Stream<FeatureOnboardingState> get stream => Stream.value(_state);
  
  @override
  bool get isClosed => false;
  
  @override
  void emit(FeatureOnboardingState state) {
    when(() => this.state).thenReturn(state);
  }
  
  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
  
  @override
  void onError(Object error, StackTrace stackTrace) {}
  
  @override
  void onChange(Change<FeatureOnboardingState> change) {}
  
  @override
  Future<void> close() async {}
  
  // Helper method to set the state for testing
  void setState(FeatureOnboardingState state) {
    when(() => this.state).thenReturn(state);
  }
}

class TestSetup {
  static Future<void> initializeTestDI() async {
    // Reset GetIt instance
    await GetIt.instance.reset();
    
    // Register mocks for external dependencies
  GetIt.instance.registerLazySingleton<DioClient>(() => MockDioClient());
  GetIt.instance.registerLazySingleton<NetworkInfo>(() => MockNetworkInfo());
  // Create a MockThemeService instance so we can stub its properties
  final mockThemeService = MockThemeService();
  // Default themeMode must be non-null for ThemeToggleButton
  when(() => mockThemeService.themeMode).thenReturn(ThemeMode.light);
  when(() => mockThemeService.toggleTheme()).thenAnswer((_) async {});
  if (!GetIt.instance.isRegistered<ThemeService>()) {
    GetIt.instance.registerLazySingleton<ThemeService>(() => mockThemeService);
  }
    
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
      home: ChangeNotifierProvider<ThemeService>.value(
        value: GetIt.instance.get<ThemeService>(),
        child: MultiBlocProvider(
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
      ),
    );
  }

  static void tearDown() {
  GetIt.instance.reset();
  }
} 