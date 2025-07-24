import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/asset_management/data/models/asset_model.dart';

abstract class AssetRepository {
  Future<Either<Failure, List<AssetModel>>> getPlaceAssets(String placeId);
  Future<Either<Failure, String>> downloadAsset(AssetModel asset);
  Future<Either<Failure, void>> cacheAsset(AssetModel asset, String localPath);
  Future<Either<Failure, List<AssetModel>>> getCachedAssets(String placeId);
  Future<Either<Failure, void>> clearCache();
}
