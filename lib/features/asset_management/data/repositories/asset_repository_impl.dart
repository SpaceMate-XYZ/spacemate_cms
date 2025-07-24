import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/services/permission_service.dart';
import 'package:spacemate/features/asset_management/data/datasources/asset_local_data_source.dart';
import 'package:spacemate/features/asset_management/data/models/asset_model.dart';
import 'package:spacemate/features/asset_management/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDataSource localDataSource;
  final Dio dio;
  final PermissionService permissionService;

  AssetRepositoryImpl({
    required this.localDataSource,
    required this.dio,
    required this.permissionService,
  });

  @override
  Future<Either<Failure, List<AssetModel>>> getPlaceAssets(String placeId) async {
    try {
      // First check local cache
      final cachedAssets = await localDataSource.getCachedAssets(placeId);
      if (cachedAssets.isNotEmpty) {
        return Right(cachedAssets);
      }

      // If not in cache, fetch from API
      // TODO: Replace with actual API call to NestJS
      final response = await dio.get('/api/places/$placeId/assets');
      
      if (response.statusCode == 200) {
        final List<dynamic> assetsJson = response.data['data'];
        final assets = assetsJson
            .map((json) => AssetModel.fromJson(json))
            .toList();
        
        // Cache the assets
        await localDataSource.updatePlaceAssets(placeId, assets);
        
        return Right(assets);
      } else {
        return const Left(ServerFailure('Failed to load assets'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadAsset(AssetModel asset) async {
    try {
      // Check and request storage permission
      final hasPermission = await permissionService.requestStoragePermission();
      if (!hasPermission) {
        return const Left(UnauthorizedFailure('Storage permission denied'));
      }

      // Get the directory for downloads
      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/${asset.id}_${DateTime.now().millisecondsSinceEpoch}.${_getFileExtension(asset.url)}';
      
      // Start download
      final taskId = await FlutterDownloader.enqueue(
        url: asset.url,
        savedDir: directory.path,
        fileName: '${asset.id}_${DateTime.now().millisecondsSinceEpoch}.${_getFileExtension(asset.url)}',
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId == null) {
        return const Left(ServerFailure('Failed to start download'));
      }

      // Wait for download to complete
      final downloadStatus = await _monitorDownload(taskId);
      
      if (downloadStatus == DownloadTaskStatus.complete) {
        return Right(savePath);
      } else {
        return const Left(ServerFailure('Download failed'));
      }
    } catch (e) {
      return Left(ServerFailure('Download error: $e'));
    }
  }

  Future<DownloadTaskStatus> _monitorDownload(String taskId) async {
    // Check status periodically until download completes or fails
    while (true) {
      final tasks = await FlutterDownloader.loadTasks();
      final task = tasks?.firstWhere((t) => t.taskId == taskId);
      
      if (task == null) {
        return DownloadTaskStatus.undefined;
      }
      
      if (task.status == DownloadTaskStatus.complete ||
          task.status == DownloadTaskStatus.failed ||
          task.status == DownloadTaskStatus.canceled) {
        return task.status;
      }
      
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  String _getFileExtension(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      return path.split('.').last.toLowerCase();
    } catch (e) {
      return 'bin';
    }
  }

  @override
  Future<Either<Failure, void>> cacheAsset(AssetModel asset, String localPath) async {
    try {
      await localDataSource.cacheAsset(
        asset.copyWith(localPath: localPath, lastUpdated: DateTime.now()),
        localPath,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to cache asset: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AssetModel>>> getCachedAssets(String placeId) async {
    try {
      final assets = await localDataSource.getCachedAssets(placeId);
      return Right(assets);
    } catch (e) {
      return Left(CacheFailure('Failed to get cached assets: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear cache: $e'));
    }
  }
}
