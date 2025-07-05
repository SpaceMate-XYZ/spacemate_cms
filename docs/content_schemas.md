# Content Schemas & Data Structures

This document describes the data structures and schemas used in the SpaceMate CMS app, covering the new NestJS + MinIO architecture with place-specific content management.

---

## 1. NestJS API Response Schemas

### Place Assets API Response

**Endpoint**: `GET /place-app-assets/:placeId`

**Response Structure**:
```json
{
  "placeId": "place-001",
  "menus": {
    "screens": [
      {
        "id": 1,
        "slug": "home",
        "label": "Home",
        "icon": "home",
        "order": 1,
        "isVisible": true,
        "isAvailable": true,
        "badgeCount": 0,
        "features": [
          {
            "id": 1,
            "slug": "parking",
            "label": "Parking",
            "icon": "local_parking",
            "order": 1,
            "isVisible": true,
            "isAvailable": true,
            "badgeCount": 0
          }
        ]
      }
    ]
  },
  "onboarding": {
    "parking": [
      {
        "id": 1,
        "screen": 1,
        "title": "Welcome to Parking",
        "imageUrl": "https://cdn.cloudflare.com/parking_1.jpg",
        "header": "Find Your Spot",
        "body": "Easy parking solutions for your convenience",
        "buttonLabel": "Get Started"
      },
      {
        "id": 2,
        "screen": 2,
        "title": "Smart Parking",
        "imageUrl": "https://cdn.cloudflare.com/parking_2.jpg",
        "header": "Smart Technology",
        "body": "Advanced parking technology for better experience",
        "buttonLabel": "Learn More"
      },
      {
        "id": 3,
        "screen": 3,
        "title": "Payment Options",
        "imageUrl": "https://cdn.cloudflare.com/parking_3.jpg",
        "header": "Easy Payment",
        "body": "Multiple payment options for your convenience",
        "buttonLabel": "Continue"
      },
      {
        "id": 4,
        "screen": 4,
        "title": "Ready to Go",
        "imageUrl": "https://cdn.cloudflare.com/parking_4.jpg",
        "header": "You're All Set",
        "body": "Start using our parking services now",
        "buttonLabel": "Get Started"
      }
    ],
    "valetparking": [
      {
        "id": 5,
        "screen": 1,
        "title": "Valet Parking",
        "imageUrl": "https://cdn.cloudflare.com/valet_1.jpg",
        "header": "Premium Service",
        "body": "Professional valet parking service",
        "buttonLabel": "Get Started"
      }
    ]
  },
  "images": [
    {
      "id": "parking_1",
      "url": "https://cdn.cloudflare.com/parking_1.jpg",
      "localPath": "images/parking_1.jpg",
      "size": 245760,
      "width": 1024,
      "height": 768
    },
    {
      "id": "parking_2",
      "url": "https://cdn.cloudflare.com/parking_2.jpg",
      "localPath": "images/parking_2.jpg",
      "size": 198432,
      "width": 1024,
      "height": 768
    }
  ],
  "metadata": {
    "version": "1.2.0",
    "lastUpdated": "2024-01-15T10:30:00Z",
    "totalSize": 5242880,
    "checksum": "sha256:abc123...",
    "compression": "gzip"
  }
}
```

### Version Check API Response

**Endpoint**: `GET /place-app-assets/:placeId/version`

**Response Structure**:
```json
{
  "placeId": "place-001",
  "version": "1.2.0",
  "lastUpdated": "2024-01-15T10:30:00Z",
  "totalSize": 5242880,
  "hasUpdates": true
}
```

---

## 2. MinIO Storage Structure

### Directory Structure

```
minio/
├── places/
│   ├── place-001/
│   │   ├── metadata.json
│   │   ├── menus.json
│   │   ├── onboarding/
│   │   │   ├── parking.json
│   │   │   ├── valetparking.json
│   │   │   ├── meeting.json
│   │   │   └── facilities.json
│   │   └── images/
│   │       ├── parking_1.jpg
│   │       ├── parking_2.jpg
│   │       ├── parking_3.jpg
│   │       ├── parking_4.jpg
│   │       ├── valet_1.jpg
│   │       └── valet_2.jpg
│   ├── place-002/
│   │   ├── metadata.json
│   │   ├── menus.json
│   │   ├── onboarding/
│   │   └── images/
│   └── place-003/
│       └── ...
```

### Metadata File Structure

**File**: `places/place-001/metadata.json`

```json
{
  "placeId": "place-001",
  "name": "Downtown Office Building",
  "version": "1.2.0",
  "lastUpdated": "2024-01-15T10:30:00Z",
  "totalSize": 5242880,
  "checksum": "sha256:abc123...",
  "compression": "gzip",
  "features": [
    "parking",
    "valetparking",
    "meeting",
    "facilities"
  ],
  "imageCount": 6,
  "onboardingCount": 4
}
```

### Menu Data Structure

**File**: `places/place-001/menus.json`

```json
{
  "screens": [
    {
      "id": 1,
      "slug": "home",
      "label": "Home",
      "icon": "home",
      "order": 1,
      "isVisible": true,
      "isAvailable": true,
      "badgeCount": 0,
      "features": [
        {
          "id": 1,
          "slug": "parking",
          "label": "Parking",
          "icon": "local_parking",
          "order": 1,
          "isVisible": true,
          "isAvailable": true,
          "badgeCount": 0
        },
        {
          "id": 2,
          "slug": "valetparking",
          "label": "Valet Parking",
          "icon": "directions_car",
          "order": 2,
          "isVisible": true,
          "isAvailable": true,
          "badgeCount": 0
        }
      ]
    },
    {
      "id": 2,
      "slug": "transport",
      "label": "Transport",
      "icon": "directions_bus",
      "order": 2,
      "isVisible": true,
      "isAvailable": true,
      "badgeCount": 0,
      "features": [
        {
          "id": 3,
          "slug": "shuttle",
          "label": "Shuttle Service",
          "icon": "airport_shuttle",
          "order": 1,
          "isVisible": true,
          "isAvailable": true,
          "badgeCount": 0
        }
      ]
    }
  ]
}
```

### Onboarding Data Structure

**File**: `places/place-001/onboarding/parking.json`

```json
[
  {
    "id": 1,
    "screen": 1,
    "title": "Welcome to Parking",
    "imageUrl": "https://cdn.cloudflare.com/parking_1.jpg",
    "header": "Find Your Spot",
    "body": "Easy parking solutions for your convenience. Our smart parking system helps you find available spots quickly and efficiently.",
    "buttonLabel": "Get Started"
  },
  {
    "id": 2,
    "screen": 2,
    "title": "Smart Parking",
    "imageUrl": "https://cdn.cloudflare.com/parking_2.jpg",
    "header": "Smart Technology",
    "body": "Advanced parking technology for better experience. Real-time availability and automated payment systems.",
    "buttonLabel": "Learn More"
  },
  {
    "id": 3,
    "screen": 3,
    "title": "Payment Options",
    "imageUrl": "https://cdn.cloudflare.com/parking_3.jpg",
    "header": "Easy Payment",
    "body": "Multiple payment options for your convenience. Credit cards, mobile payments, and contactless options available.",
    "buttonLabel": "Continue"
  },
  {
    "id": 4,
    "screen": 4,
    "title": "Ready to Go",
    "imageUrl": "https://cdn.cloudflare.com/parking_4.jpg",
    "header": "You're All Set",
    "body": "Start using our parking services now. Enjoy hassle-free parking with our smart solutions.",
    "buttonLabel": "Get Started"
  }
]
```

---

## 3. Local SQLite Database Schemas

### Places Table

```sql
CREATE TABLE places (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  version TEXT NOT NULL,
  last_updated INTEGER NOT NULL,
  total_size INTEGER NOT NULL,
  is_downloaded BOOLEAN DEFAULT FALSE,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE INDEX idx_places_id ON places(id);
CREATE INDEX idx_places_version ON places(version);
```

### Place Assets Table

```sql
CREATE TABLE place_assets (
  id INTEGER PRIMARY KEY,
  place_id TEXT NOT NULL,
  asset_type TEXT NOT NULL, -- 'menu', 'onboarding', 'image'
  asset_key TEXT NOT NULL,
  asset_data TEXT NOT NULL,
  local_path TEXT,
  file_size INTEGER,
  cached_at INTEGER NOT NULL,
  FOREIGN KEY (place_id) REFERENCES places(id)
);

CREATE INDEX idx_place_assets_place_id ON place_assets(place_id);
CREATE INDEX idx_place_assets_type ON place_assets(asset_type);
CREATE INDEX idx_place_assets_key ON place_assets(asset_key);
```

### Image Cache Table

```sql
CREATE TABLE image_cache (
  id INTEGER PRIMARY KEY,
  place_id TEXT NOT NULL,
  image_id TEXT NOT NULL,
  local_path TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  width INTEGER,
  height INTEGER,
  cached_at INTEGER NOT NULL,
  last_accessed INTEGER NOT NULL,
  FOREIGN KEY (place_id) REFERENCES places(id)
);

CREATE INDEX idx_image_cache_place_id ON image_cache(place_id);
CREATE INDEX idx_image_cache_image_id ON image_cache(image_id);
CREATE INDEX idx_image_cache_accessed ON image_cache(last_accessed);
```

### Cache Metadata Table

```sql
CREATE TABLE cache_metadata (
  id INTEGER PRIMARY KEY,
  place_id TEXT NOT NULL,
  metadata_key TEXT NOT NULL,
  metadata_value TEXT NOT NULL,
  cached_at INTEGER NOT NULL,
  FOREIGN KEY (place_id) REFERENCES places(id)
);

CREATE INDEX idx_cache_metadata_place_id ON cache_metadata(place_id);
CREATE INDEX idx_cache_metadata_key ON cache_metadata(metadata_key);
```

---

## 4. Flutter Model Classes

### Place Assets Response Model

```dart
class PlaceAssetsResponse {
  final String placeId;
  final MenuData menus;
  final Map<String, List<OnboardingSlide>> onboarding;
  final List<ImageAsset> images;
  final AssetMetadata metadata;

  PlaceAssetsResponse({
    required this.placeId,
    required this.menus,
    required this.onboarding,
    required this.images,
    required this.metadata,
  });

  factory PlaceAssetsResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAssetsResponse(
      placeId: json['placeId'] as String,
      menus: MenuData.fromJson(json['menus'] as Map<String, dynamic>),
      onboarding: (json['onboarding'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => OnboardingSlide.fromJson(e)).toList(),
        ),
      ),
      images: (json['images'] as List)
          .map((e) => ImageAsset.fromJson(e))
          .toList(),
      metadata: AssetMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'menus': menus.toJson(),
      'onboarding': onboarding.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
      'images': images.map((e) => e.toJson()).toList(),
      'metadata': metadata.toJson(),
    };
  }
}
```

### Menu Data Model

```dart
class MenuData {
  final List<MenuScreen> screens;

  MenuData({required this.screens});

  factory MenuData.fromJson(Map<String, dynamic> json) {
    return MenuData(
      screens: (json['screens'] as List)
          .map((e) => MenuScreen.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screens': screens.map((e) => e.toJson()).toList(),
    };
  }
}

class MenuScreen {
  final int id;
  final String slug;
  final String label;
  final String icon;
  final int order;
  final bool isVisible;
  final bool isAvailable;
  final int badgeCount;
  final List<MenuFeature> features;

  MenuScreen({
    required this.id,
    required this.slug,
    required this.label,
    required this.icon,
    required this.order,
    required this.isVisible,
    required this.isAvailable,
    required this.badgeCount,
    required this.features,
  });

  factory MenuScreen.fromJson(Map<String, dynamic> json) {
    return MenuScreen(
      id: json['id'] as int,
      slug: json['slug'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      order: json['order'] as int,
      isVisible: json['isVisible'] as bool,
      isAvailable: json['isAvailable'] as bool,
      badgeCount: json['badgeCount'] as int,
      features: (json['features'] as List)
          .map((e) => MenuFeature.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'label': label,
      'icon': icon,
      'order': order,
      'isVisible': isVisible,
      'isAvailable': isAvailable,
      'badgeCount': badgeCount,
      'features': features.map((e) => e.toJson()).toList(),
    };
  }
}

class MenuFeature {
  final int id;
  final String slug;
  final String label;
  final String icon;
  final int order;
  final bool isVisible;
  final bool isAvailable;
  final int badgeCount;

  MenuFeature({
    required this.id,
    required this.slug,
    required this.label,
    required this.icon,
    required this.order,
    required this.isVisible,
    required this.isAvailable,
    required this.badgeCount,
  });

  factory MenuFeature.fromJson(Map<String, dynamic> json) {
    return MenuFeature(
      id: json['id'] as int,
      slug: json['slug'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      order: json['order'] as int,
      isVisible: json['isVisible'] as bool,
      isAvailable: json['isAvailable'] as bool,
      badgeCount: json['badgeCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'label': label,
      'icon': icon,
      'order': order,
      'isVisible': isVisible,
      'isAvailable': isAvailable,
      'badgeCount': badgeCount,
    };
  }
}
```

### Onboarding Slide Model

```dart
class OnboardingSlide {
  final int id;
  final int screen;
  final String title;
  final String imageUrl;
  final String header;
  final String body;
  final String buttonLabel;

  OnboardingSlide({
    required this.id,
    required this.screen,
    required this.title,
    required this.imageUrl,
    required this.header,
    required this.body,
    required this.buttonLabel,
  });

  factory OnboardingSlide.fromJson(Map<String, dynamic> json) {
    return OnboardingSlide(
      id: json['id'] as int,
      screen: json['screen'] as int,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      header: json['header'] as String,
      body: json['body'] as String,
      buttonLabel: json['buttonLabel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screen': screen,
      'title': title,
      'imageUrl': imageUrl,
      'header': header,
      'body': body,
      'buttonLabel': buttonLabel,
    };
  }
}
```

### Image Asset Model

```dart
class ImageAsset {
  final String id;
  final String url;
  final String localPath;
  final int size;
  final int? width;
  final int? height;

  ImageAsset({
    required this.id,
    required this.url,
    required this.localPath,
    required this.size,
    this.width,
    this.height,
  });

  factory ImageAsset.fromJson(Map<String, dynamic> json) {
    return ImageAsset(
      id: json['id'] as String,
      url: json['url'] as String,
      localPath: json['localPath'] as String,
      size: json['size'] as int,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'localPath': localPath,
      'size': size,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    };
  }
}
```

### Asset Metadata Model

```dart
class AssetMetadata {
  final String version;
  final String lastUpdated;
  final int totalSize;
  final String? checksum;
  final String? compression;

  AssetMetadata({
    required this.version,
    required this.lastUpdated,
    required this.totalSize,
    this.checksum,
    this.compression,
  });

  factory AssetMetadata.fromJson(Map<String, dynamic> json) {
    return AssetMetadata(
      version: json['version'] as String,
      lastUpdated: json['lastUpdated'] as String,
      totalSize: json['totalSize'] as int,
      checksum: json['checksum'] as String?,
      compression: json['compression'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'lastUpdated': lastUpdated,
      'totalSize': totalSize,
      if (checksum != null) 'checksum': checksum,
      if (compression != null) 'compression': compression,
    };
  }
}
```

---

## 5. Refine.dev Admin Panel Schemas

### Place Form Schema

```typescript
interface PlaceFormData {
  placeId: string;
  name: string;
  description?: string;
  location?: string;
  menus: MenuFormData;
  onboarding: OnboardingFormData;
  images: ImageFormData[];
}

interface MenuFormData {
  screens: ScreenFormData[];
}

interface ScreenFormData {
  id?: number;
  slug: string;
  label: string;
  icon: string;
  order: number;
  isVisible: boolean;
  isAvailable: boolean;
  badgeCount: number;
  features: FeatureFormData[];
}

interface FeatureFormData {
  id?: number;
  slug: string;
  label: string;
  icon: string;
  order: number;
  isVisible: boolean;
  isAvailable: boolean;
  badgeCount: number;
}

interface OnboardingFormData {
  [featureName: string]: OnboardingSlideFormData[];
}

interface OnboardingSlideFormData {
  id?: number;
  screen: number;
  title: string;
  imageUrl: string;
  header: string;
  body: string;
  buttonLabel: string;
}

interface ImageFormData {
  id: string;
  file: File;
  url?: string;
  localPath?: string;
  size?: number;
  width?: number;
  height?: number;
}
```

---

## 6. Test Fixtures

### Sample Place Assets Response

**File**: `test/fixtures/place_assets_response.json`

```json
{
  "placeId": "test-place-001",
  "menus": {
    "screens": [
      {
        "id": 1,
        "slug": "home",
        "label": "Home",
        "icon": "home",
        "order": 1,
        "isVisible": true,
        "isAvailable": true,
        "badgeCount": 0,
        "features": [
          {
            "id": 1,
            "slug": "parking",
            "label": "Parking",
            "icon": "local_parking",
            "order": 1,
            "isVisible": true,
            "isAvailable": true,
            "badgeCount": 0
          }
        ]
      }
    ]
  },
  "onboarding": {
    "parking": [
      {
        "id": 1,
        "screen": 1,
        "title": "Welcome to Parking",
        "imageUrl": "https://cdn.cloudflare.com/parking_1.jpg",
        "header": "Find Your Spot",
        "body": "Easy parking solutions for your convenience",
        "buttonLabel": "Get Started"
      }
    ]
  },
  "images": [
    {
      "id": "parking_1",
      "url": "https://cdn.cloudflare.com/parking_1.jpg",
      "localPath": "images/parking_1.jpg",
      "size": 245760,
      "width": 1024,
      "height": 768
    }
  ],
  "metadata": {
    "version": "1.0.0",
    "lastUpdated": "2024-01-15T10:30:00Z",
    "totalSize": 245760,
    "checksum": "sha256:test123...",
    "compression": "gzip"
  }
}
```

### Sample MinIO Metadata

**File**: `test/fixtures/minio_metadata.json`

```json
{
  "placeId": "test-place-001",
  "name": "Test Office Building",
  "version": "1.0.0",
  "lastUpdated": "2024-01-15T10:30:00Z",
  "totalSize": 245760,
  "checksum": "sha256:test123...",
  "compression": "gzip",
  "features": ["parking"],
  "imageCount": 1,
  "onboardingCount": 1
}
```

---

## 7. Migration Notes

### From Strapi to NestJS + MinIO

**Key Changes**:
1. **API Structure**: Changed from Strapi REST API to NestJS custom endpoints
2. **Storage**: Moved from Strapi media library to MinIO object storage
3. **Content Organization**: Place-specific content structure instead of global collections
4. **Versioning**: Added semantic versioning for content updates
5. **Offline Strategy**: Enhanced offline-first approach with flutter_downloader

**Backward Compatibility**:
- Strapi remains as fallback for content refresh
- Existing Strapi data can be migrated to MinIO
- Flutter app supports both old and new data sources

---

**This schema documentation provides comprehensive coverage of the new NestJS + MinIO architecture with place-specific content management and offline-first capabilities.** 