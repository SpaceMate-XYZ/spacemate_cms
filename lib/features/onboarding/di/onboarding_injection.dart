import 'package:get_it/get_it.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_carousel_dao.dart';
import 'package:spacemate/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:spacemate/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:spacemate/features/onboarding/domain/usecases/get_features_with_onboarding.dart';
import 'package:spacemate/features/onboarding/domain/usecases/get_feature_by_name.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';

final sl = GetIt.instance;

void initOnboardingFeature() {
  // Data sources
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(dioClient: sl()),
  );

  // DAOs
  sl.registerLazySingleton<OnboardingCarouselDao>(
    () => OnboardingCarouselDao(),
  );

  // Ensure NetworkInfo is registered
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  }

  // Repositories
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(
      remoteDataSource: sl(),
      carouselDao: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFeaturesWithOnboarding(sl()));
  sl.registerLazySingleton(() => GetFeatureByName(sl()));

  // Bloc
  sl.registerFactory(() => OnboardingBloc(getFeaturesWithOnboarding: sl()));

  // Cubit
  sl.registerFactory(() => FeatureOnboardingCubit(
        getFeaturesWithOnboarding: sl(),
        getFeatureByName: sl(),
        sharedPreferences: sl(),
      ));
}
