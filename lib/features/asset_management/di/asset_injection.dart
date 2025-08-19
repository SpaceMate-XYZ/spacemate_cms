import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:spacemate/core/services/permission_service.dart';
import 'package:spacemate/features/asset_management/data/datasources/asset_local_data_source.dart';
import 'package:spacemate/features/asset_management/data/repositories/asset_repository_impl.dart';
import 'package:spacemate/features/asset_management/domain/repositories/asset_repository.dart';
import 'package:sqflite/sqflite.dart';

Future<void> initAssetDependencies(GetIt sl) async {
  // Register Permission Service
  if (!sl.isRegistered<PermissionService>()) {
    sl.registerLazySingleton<PermissionService>(() => PermissionService());
  }

  // Register Local Data Source
  if (!sl.isRegistered<AssetLocalDataSource>()) {
    sl.registerLazySingleton<AssetLocalDataSource>(
      () => AssetLocalDataSourceImpl(database: sl<Database>()),
    );
  }

  // Register Repository
  if (!sl.isRegistered<AssetRepository>()) {
    sl.registerLazySingleton<AssetRepository>(
      () => AssetRepositoryImpl(
        localDataSource: sl<AssetLocalDataSource>(),
        dio: sl<Dio>(),
        permissionService: sl<PermissionService>(),
      ),
    );
  }
}
