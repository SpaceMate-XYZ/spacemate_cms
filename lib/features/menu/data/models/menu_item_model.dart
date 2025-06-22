import 'package:spacemate/core/utils/string_extensions.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required String id,
    required String title,
    required String icon,
    required MenuCategory category,
    required String route,
    bool isActive = true,
    int? order,
    int badgeCount = 0,
    List<String> requiredPermissions = const [],
    required String analyticsId,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          title: title,
          icon: icon,
          category: category,
          route: route,
          isActive: isActive,
          order: order,
          badgeCount: badgeCount,
          requiredPermissions: requiredPermissions,
          analyticsId: analyticsId,
          imageUrl: imageUrl,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        
  const MenuItemModel.empty()
      : this(
          id: '',
          title: '',
          icon: '',
          category: MenuCategory.home,
          route: '',
          analyticsId: '',
          isActive: false,
          badgeCount: 0,
          requiredPermissions: const [],
          createdAt: null,
          updatedAt: null,
        );

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] is MenuCategory
        ? json['category'] as MenuCategory
        : MenuCategoryX.fromString(json['category'].toString());
        
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      category: category,
      route: json['route']?.toString() ?? '',
      isActive: (json['is_active'] is int && (json['is_active'] as int) == 1) ||
          (json['isActive'] is bool ? (json['isActive'] as bool) : true),
      order: (json['order'] as int?)?.toInt(),
      badgeCount: (json['badge_count'] as int?) ??
          (json['badgeCount'] as int?) ??
          0,
      requiredPermissions: _parsePermissions(
        json['required_permissions'] ?? json['requiredPermissions'],
      ),
      analyticsId: json['analytics_id']?.toString() ??
          json['analyticsId']?.toString() ??
          '',
      imageUrl: json['image_url']?.toString() ?? json['imageUrl']?.toString(),
      createdAt: json['created_at'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int)
          : json['created_at'] is String
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
      updatedAt: json['updated_at'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['updated_at'] as int)
          : json['updated_at'] is String
              ? DateTime.tryParse(json['updated_at'] as String)
              : null,
    );
  }

  static List<String> _parsePermissions(dynamic permissions) {
    if (permissions == null) return const [];
    if (permissions is List) {
      return permissions.map((e) => e?.toString() ?? '').toList();
    }
    if (permissions is String) {
      return permissions.split(',').map((e) => e.trim()).toList();
    }
    return [permissions.toString()];
  }

  /// Converts the model to an entity
  MenuItemEntity toEntity() {
    return MenuItemEntity(
      id: id,
      title: title,
      icon: icon,
      category: category,
      route: route,
      isActive: isActive,
      order: order,
      badgeCount: badgeCount,
      requiredPermissions: List.from(requiredPermissions),
      analyticsId: analyticsId,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'category': category.toString(),
      'route': route,
      'is_active': isActive ? 1 : 0,
      'isActive': isActive,
      'order': order,
      'badge_count': badgeCount,
      'badgeCount': badgeCount,
      'required_permissions': requiredPermissions,
      'requiredPermissions': requiredPermissions,
      'analytics_id': analyticsId,
      'analyticsId': analyticsId,
      'image_url': imageUrl,
      'imageUrl': imageUrl,
      if (createdAt != null) 'created_at': createdAt!.millisecondsSinceEpoch,
      if (updatedAt != null) 'updated_at': updatedAt!.millisecondsSinceEpoch,
    }..removeWhere((key, value) => value == null);
  }



  @override
  MenuItemModel copyWith({
    String? id,
    String? title,
    String? icon,
    MenuCategory? category,
    String? route,
    bool? isActive,
    int? order,
    int? badgeCount,
    List<String>? requiredPermissions,
    String? analyticsId,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool updateTimestamps = false,
  }) {
    final now = DateTime.now();
    return MenuItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      route: route ?? this.route,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      badgeCount: badgeCount ?? this.badgeCount,
      requiredPermissions: requiredPermissions ?? this.requiredPermissions,
      analyticsId: analyticsId ?? this.analyticsId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? (updateTimestamps ? now : this.createdAt),
      updatedAt: updatedAt ?? (updateTimestamps ? now : this.updatedAt),
    );
  }
}
