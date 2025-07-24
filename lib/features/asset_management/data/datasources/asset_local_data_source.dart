import 'package:sqflite/sqflite.dart';
import 'package:spacemate/features/asset_management/data/models/asset_model.dart';

abstract class AssetLocalDataSource {
  Future<void> cacheAsset(AssetModel asset, String localPath);
  Future<void> updatePlaceAssets(String placeId, List<AssetModel> assets);
  Future<List<AssetModel>> getCachedAssets(String placeId);
  Future<AssetModel?> getCachedAsset(String assetId);
  Future<void> clearCache();
}

class AssetLocalDataSourceImpl implements AssetLocalDataSource {
  final Database database;

  AssetLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheAsset(AssetModel asset, String localPath) async {
    await database.insert(
      'cached_assets',
      {
        'id': asset.id,
        'url': asset.url,
        'type': asset.type,
        'local_path': localPath,
        'last_updated': DateTime.now().toIso8601String(),
        'metadata': asset.metadata?.toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updatePlaceAssets(String placeId, List<AssetModel> assets) async {
    final batch = database.batch();
    
    for (final asset in assets) {
      batch.insert(
        'place_assets',
        {
          'place_id': placeId,
          'asset_id': asset.id,
          'last_updated': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  @override
  Future<List<AssetModel>> getCachedAssets(String placeId) async {
    final List<Map<String, dynamic>> maps = await database.rawQuery('''
      SELECT ca.* 
      FROM cached_assets ca
      INNER JOIN place_assets pa ON ca.id = pa.asset_id
      WHERE pa.place_id = ?
    ''', [placeId]);

    return maps.map((json) => AssetModel.fromJson(json)).toList();
  }

  @override
  Future<AssetModel?> getCachedAsset(String assetId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'cached_assets',
      where: 'id = ?',
      whereArgs: [assetId],
    );

    if (maps.isNotEmpty) {
      return AssetModel.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await database.delete('cached_assets');
    await database.delete('place_assets');
  }
}
