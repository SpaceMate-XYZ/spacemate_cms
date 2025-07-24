import 'package:json_annotation/json_annotation.dart';

part 'asset_model.g.dart';

@JsonSerializable()
class AssetModel {
  final String id;
  final String url;
  final String type; // 'image', 'json', etc.
  final String? localPath;
  final DateTime? lastUpdated;
  final Map<String, dynamic>? metadata;

  const AssetModel({
    required this.id,
    required this.url,
    required this.type,
    this.localPath,
    this.lastUpdated,
    this.metadata,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) => 
      _$AssetModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$AssetModelToJson(this);

  AssetModel copyWith({
    String? localPath,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) {
    return AssetModel(
      id: id,
      url: url,
      type: type,
      localPath: localPath ?? this.localPath,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      metadata: metadata ?? this.metadata,
    );
  }
}
