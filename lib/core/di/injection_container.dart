import 'package:connectivity_plus/connectivity_plus.dart';
// Added import
import 'package:get_it/get_it.dart';
import 'package:spacemate/core/config/app_config.dart';
import 'package:spacemate/core/database/database_helper.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/core/theme/theme_service.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_local_data_source.dart';
import 'package:spacemate/features/menu/data/datasources/menu_local_data_source.dart' as data_source;
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source_impl.dart';
import 'package:spacemate/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_items.dart';

import 'package:spacemate/features/carousel/di/carousel_injection.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/onboarding/di/onboarding_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init({required String baseUrl}) async {
  //! Features
  _initMenuFeature();
  await initCarouselDependencies();
  initOnboardingFeature();

  //! External
  await _initExternalDependencies(baseUrl: baseUrl);
}

void _initMenuFeature() {
  // Bloc
  sl.registerFactory(
    () => MenuBloc(
      getMenuItems: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => GetMenuItems(sl()));
  

  // Repository
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<MenuLocalDataSource>(
    () => data_source.MenuLocalDataSourceImpl(dbHelper: sl()),
  );
}

Future<void> _initExternalDependencies({required String baseUrl}) async {
  // Database
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
  await sl<DatabaseHelper>().initialize();

  // Theme Service
  sl.registerLazySingleton<ThemeService>(() => ThemeService());
  await sl<ThemeService>().init();

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Network
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<Connectivity>()));

  // Dio
  final dioClient = DioClient(
    baseUrl: baseUrl,
    authToken: AppConfig.apiToken, // Use API token from config if available
  );
  await dioClient.init();
  sl.registerLazySingleton<DioClient>(() => dioClient);
}
