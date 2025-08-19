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
  if (!sl.isRegistered<OnboardingRemoteDataSource>()) {
    sl.registerLazySingleton<OnboardingRemoteDataSource>(
      () => OnboardingRemoteDataSourceImpl(dioClient: sl()),
    );
  }

  // DAOs
  if (!sl.isRegistered<OnboardingCarouselDao>()) {
    sl.registerLazySingleton<OnboardingCarouselDao>(
      () => OnboardingCarouselDao(),
    );
  }

  // Ensure NetworkInfo is registered
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  }

  // Repositories
  if (!sl.isRegistered<OnboardingRepository>()) {
    sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(
        remoteDataSource: sl(),
        carouselDao: sl(),
        networkInfo: sl(),
      ),
    );
  }

  // Use cases
  if (!sl.isRegistered<GetFeaturesWithOnboarding>()) {
    sl.registerLazySingleton(() => GetFeaturesWithOnboarding(sl()));
  }
  if (!sl.isRegistered<GetFeatureByName>()) {
    sl.registerLazySingleton(() => GetFeatureByName(sl()));
  }

  // Bloc
  if (!sl.isRegistered<OnboardingBloc>()) {
    sl.registerFactory(() => OnboardingBloc(getFeaturesWithOnboarding: sl()));
  }

  // Cubit
  if (!sl.isRegistered<FeatureOnboardingCubit>()) {
    sl.registerFactory(() => FeatureOnboardingCubit(
          getFeaturesWithOnboarding: sl(),
          getFeatureByName: sl(),
          sharedPreferences: sl(),
        ));
  }
}
