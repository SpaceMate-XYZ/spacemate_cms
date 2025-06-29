import 'package:equatable/equatable.dart';
import 'package:spacemate/features/carousel/domain/entities/carousel_item_entity.dart';
import 'package:spacemate/core/config/app_config.dart';

class StrapiCarouselResponse extends Equatable {
  final List<StrapiCarouselItem> data;
  final StrapiMeta meta;

  const StrapiCarouselResponse({
    required this.data,
    required this.meta,
  });

  factory StrapiCarouselResponse.fromJson(Map<String, dynamic> json) {
    return StrapiCarouselResponse(
      data: (json['data'] as List)
          .map((e) => StrapiCarouselItem.fromJson(e))
          .toList(),
      meta: StrapiMeta.fromJson(json['meta']),
    );
  }

  @override
  List<Object?> get props => [data, meta];
}

class StrapiCarouselItem extends Equatable {
  final int id;
  final StrapiCarouselAttributes attributes;

  const StrapiCarouselItem({
    required this.id,
    required this.attributes,
  });

  factory StrapiCarouselItem.fromJson(Map<String, dynamic> json) {
    return StrapiCarouselItem(
      id: json['id'] as int,
      attributes: StrapiCarouselAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [id, attributes];

  CarouselItemEntity toEntity() {
    return CarouselItemEntity(
      id: id.toString(),
      title: attributes.title,
      description: attributes.description,
      imageUrl: _getImageUrl(attributes.image),
      actionText: attributes.actionText,
      actionRoute: attributes.actionRoute,
      order: attributes.order,
      isActive: attributes.isActive,
      placeId: attributes.placeId,
    );
  }

  String _getImageUrl(StrapiImage? image) {
    if (image == null) return '';

    // Get the best available image size
    final url =
        image.largeUrl ?? image.mediumUrl ?? image.smallUrl ?? image.url;

    // If the URL is already absolute, return it
    if (url.startsWith('http')) {
      return url;
    }

    // Otherwise, construct the full URL using config
    final baseUrl = AppConfig.carouselStrapiBaseUrl;
    return url.startsWith('/') ? '$baseUrl$url' : '$baseUrl/$url';
  }
}

class StrapiCarouselAttributes extends Equatable {
  final String title;
  final String? description;
  final StrapiImage? image;
  final String? actionText;
  final String? actionRoute;
  final int order;
  final bool isActive;
  final String? placeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;

  const StrapiCarouselAttributes({
    required this.title,
    this.description,
    this.image,
    this.actionText,
    this.actionRoute,
    this.order = 0,
    this.isActive = true,
    this.placeId,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  factory StrapiCarouselAttributes.fromJson(Map<String, dynamic> json) {
    return StrapiCarouselAttributes(
      title: json['title'] as String,
      description: json['description'] as String?,
      image: json['image'] != null
          ? StrapiImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      actionText: json['actionText'] as String?,
      actionRoute: json['actionRoute'] as String?,
      order: json['order'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      placeId: json['placeId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        image,
        actionText,
        actionRoute,
        order,
        isActive,
        placeId,
        createdAt,
        updatedAt,
        publishedAt,
      ];
}

class StrapiImage extends Equatable {
  final int id;
  final String name;
  final String url;
  final Map<String, dynamic>? formats;

  const StrapiImage({
    required this.id,
    required this.name,
    required this.url,
    this.formats,
  });

  factory StrapiImage.fromJson(Map<String, dynamic> json) {
    return StrapiImage(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
      formats: json['formats'] as Map<String, dynamic>?,
    );
  }

  String? get smallUrl => formats?['small']?['url'] as String?;
  String? get mediumUrl => formats?['medium']?['url'] as String?;
  String? get largeUrl => formats?['large']?['url'] as String?;
  String? get thumbnailUrl => formats?['thumbnail']?['url'] as String?;

  @override
  List<Object?> get props => [id, name, url, formats];
}

class StrapiMeta extends Equatable {
  final StrapiPagination pagination;

  const StrapiMeta({required this.pagination});

  factory StrapiMeta.fromJson(Map<String, dynamic> json) {
    return StrapiMeta(
      pagination:
          StrapiPagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [pagination];
}

class StrapiPagination extends Equatable {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  const StrapiPagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory StrapiPagination.fromJson(Map<String, dynamic> json) {
    return StrapiPagination(
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      pageCount: json['pageCount'] as int,
      total: json['total'] as int,
    );
  }

  @override
  List<Object?> get props => [page, pageSize, pageCount, total];
}
