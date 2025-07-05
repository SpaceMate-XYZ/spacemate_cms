# Offline-First Content Strategy

This document describes the offline-first content strategy implemented in the SpaceMate CMS app, covering local caching, data migration, image handling, background synchronization, and error handling using a NestJS backend with MinIO storage and Refine.dev administration.

---

## 1. Architecture Overview

### ✅ New Architecture Components

**Backend Infrastructure:**
- **NestJS API:** `placeAppAssets` endpoint for place-specific content delivery
- **MinIO Storage:** Object storage for text and image assets
- **Refine.dev Admin:** Content management interface for place-specific data
- **Cloudflare CDN:** Image hosting and delivery
- **Docker Deployment:** Hosted on Hetzner with containerized services

**Flutter App Components:**
- **flutter_downloader:** Download and manage offline assets
- **file_saver:** Store downloaded content locally
- **SQLite:** Local database for cached content
- **Strapi Fallback:** Backup content refresh mechanism

### 🔄 Data Flow Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Refine.dev    │    │   NestJS API    │    │     MinIO       │
│   Admin Panel   │───▶│ placeAppAssets  │───▶│   Storage       │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Flutter App    │◀───│  flutter_downloader │    │   file_saver   │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   SQLite DB     │    │  Strapi Backup  │    │  Cloudflare CDN │
│   Local Cache   │    │   Refresh Data  │    │   Image Hosting │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## 2. Backend Infrastructure (NestJS + MinIO)

### ✅ Implemented

**NestJS API Structure:**
```typescript
// place-app-assets.controller.ts
@Controller('place-app-assets')
export class PlaceAppAssetsController {
  @Get(':placeId')
  async getPlaceAssets(@Param('placeId') placeId: string) {
    return this.placeAssetsService.getPlaceAssets(placeId);
  }
}

// place-assets.service.ts
@Injectable()
export class PlaceAssetsService {
  async getPlaceAssets(placeId: string): Promise<PlaceAssetsResponse> {
    const assets = await this.minioService.getPlaceAssets(placeId);
    return {
      placeId,
      menus: assets.menus,
      onboarding: assets.onboarding,
      images: assets.images,
      metadata: {
        version: assets.version,
        lastUpdated: assets.lastUpdated,
        totalSize: assets.totalSize
      }
    };
  }
}
```

**MinIO Storage Structure:**
```
minio/
├── places/
│   ├── place-001/
│   │   ├── menus.json
│   │   ├── onboarding/
│   │   │   ├── parking.json
│   │   │   ├── valetparking.json
│   │   │   └── ...
│   │   └── images/
│   │       ├── parking_1.jpg
│   │       ├── parking_2.jpg
│   │       └── ...
│   └── place-002/
│       └── ...
```

**API Response Format:**
```json
{
  "placeId": "place-001",
  "menus": {
    "screens": [
      {
        "id": 1,
        "slug": "home",
        "label": "Home",
        "features": [...]
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
        "body": "Easy parking solutions...",
        "buttonLabel": "Get Started"
      }
    ]
  },
  "images": [
    {
      "id": "parking_1",
      "url": "https://cdn.cloudflare.com/parking_1.jpg",
      "localPath": "images/parking_1.jpg",
      "size": 245760
    }
  ],
  "metadata": {
    "version": "1.2.0",
    "lastUpdated": "2024-01-15T10:30:00Z",
    "totalSize": 5242880
  }
}
```

---

## 3. Flutter App Integration

### ✅ Implemented

**Dependencies:**
```yaml
dependencies:
  flutter_downloader: ^1.11.6
  file_saver: ^0.2.8
  path_provider: ^2.1.1
  sqflite: ^2.3.0
```

**Asset Download Service:**
```dart
class AssetDownloadService {
  static const String _baseUrl = 'https://api.spacemate.xyz/place-app-assets';
  
  Future<void> downloadPlaceAssets(String placeId) async {
    try {
      // 1. Fetch place assets from NestJS API
      final response = await http.get(Uri.parse('$_baseUrl/$placeId'));
      final assets = PlaceAssetsResponse.fromJson(json.decode(response.body));
      
      // 2. Download and store images
      await _downloadImages(assets.images);
      
      // 3. Store JSON data locally
      await _storeJsonData(placeId, assets);
      
      // 4. Update local database
      await _updateLocalDatabase(placeId, assets);
      
    } catch (e) {
      throw AssetDownloadException('Failed to download assets: $e');
    }
  }
  
  Future<void> _downloadImages(List<ImageAsset> images) async {
    for (final image in images) {
      final taskId = await FlutterDownloader.enqueue(
        url: image.url,
        savedDir: await _getImagesDirectory(),
        fileName: image.localPath,
        showNotification: false,
        openFileFromNotification: false,
      );
      
      // Monitor download progress
      FlutterDownloader.registerCallback((id, status, progress) {
        if (id == taskId && status == DownloadTaskStatus.complete) {
          _updateImageCache(image);
        }
      });
    }
  }
  
  Future<void> _storeJsonData(String placeId, PlaceAssetsResponse assets) async {
    final directory = await getApplicationDocumentsDirectory();
    final placeDir = Directory('${directory.path}/places/$placeId');
    await placeDir.create(recursive: true);
    
    // Store menus
    final menusFile = File('${placeDir.path}/menus.json');
    await menusFile.writeAsString(json.encode(assets.menus));
    
    // Store onboarding data
    final onboardingDir = Directory('${placeDir.path}/onboarding');
    await onboardingDir.create();
    
    for (final entry in assets.onboarding.entries) {
      final featureFile = File('${onboardingDir.path}/${entry.key}.json');
      await featureFile.writeAsString(json.encode(entry.value));
    }
  }
}
```

**Local Database Schema:**
```sql
-- Places table
CREATE TABLE places (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  version TEXT NOT NULL,
  last_updated INTEGER NOT NULL,
  total_size INTEGER NOT NULL,
  is_downloaded BOOLEAN DEFAULT FALSE
);

-- Place assets table
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

-- Image cache table
CREATE TABLE image_cache (
  id INTEGER PRIMARY KEY,
  place_id TEXT NOT NULL,
  image_id TEXT NOT NULL,
  local_path TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  cached_at INTEGER NOT NULL,
  FOREIGN KEY (place_id) REFERENCES places(id)
);
```

---

## 4. Content Management (Refine.dev)

### ✅ Implemented

**Refine.dev Admin Panel:**
```typescript
// resources/places.ts
export const placesResource = {
  name: "places",
  list: "/places",
  create: "/places/create",
  edit: "/places/edit/:id",
  show: "/places/show/:id",
  meta: {
    canDelete: true,
  },
};

// components/PlaceForm.tsx
export const PlaceForm: React.FC = () => {
  const { formProps } = useForm({
    resource: "places",
    action: "create",
  });

  return (
    <Form {...formProps} layout="vertical">
      <Form.Item label="Place ID" name="placeId">
        <Input />
      </Form.Item>
      
      <Form.Item label="Place Name" name="name">
        <Input />
      </Form.Item>
      
      <Form.Item label="Menus" name="menus">
        <MenuEditor />
      </Form.Item>
      
      <Form.Item label="Onboarding Content" name="onboarding">
        <OnboardingEditor />
      </Form.Item>
      
      <Form.Item label="Images" name="images">
        <ImageUploader />
      </Form.Item>
    </Form>
  );
};
```

**Content Editor Components:**
```typescript
// components/MenuEditor.tsx
export const MenuEditor: React.FC = () => {
  return (
    <div>
      <Button onClick={addScreen}>Add Screen</Button>
      {screens.map((screen, index) => (
        <ScreenEditor key={index} screen={screen} />
      ))}
    </div>
  );
};

// components/OnboardingEditor.tsx
export const OnboardingEditor: React.FC = () => {
  return (
    <div>
      <Select onChange={setFeature}>
        <Option value="parking">Parking</Option>
        <Option value="valetparking">Valet Parking</Option>
      </Select>
      
      {slides.map((slide, index) => (
        <SlideEditor key={index} slide={slide} />
      ))}
    </div>
  );
};
```

---

## 5. Offline-First Strategy

### ✅ Implemented

**First-Time User Flow:**
```dart
class FirstTimeUserService {
  Future<void> initializePlaceContent(String placeId) async {
    // 1. Check if place assets are already downloaded
    final isDownloaded = await _checkPlaceDownloaded(placeId);
    
    if (!isDownloaded) {
      // 2. Show loading screen
      _showDownloadProgress();
      
      // 3. Download all place assets
      await assetDownloadService.downloadPlaceAssets(placeId);
      
      // 4. Mark as downloaded
      await _markPlaceDownloaded(placeId);
      
      // 5. Hide loading screen
      _hideDownloadProgress();
    }
    
    // 6. Load local content
    await _loadLocalContent(placeId);
  }
}
```

**Content Loading Strategy:**
```dart
class ContentLoadingService {
  Future<List<MenuScreen>> loadMenus(String placeId) async {
    // 1. Try local SQLite first
    final localMenus = await menuDao.getMenus(placeId);
    if (localMenus.isNotEmpty) {
      return localMenus;
    }
    
    // 2. Try local JSON files
    final jsonMenus = await _loadJsonMenus(placeId);
    if (jsonMenus.isNotEmpty) {
      await menuDao.cacheMenus(jsonMenus, placeId);
      return jsonMenus;
    }
    
    // 3. Fallback to Strapi
    return await _loadFromStrapi(placeId);
  }
  
  Future<List<OnboardingSlide>> loadOnboarding(String placeId, String feature) async {
    // 1. Try local SQLite first
    final localSlides = await onboardingDao.getSlides(placeId, feature);
    if (localSlides.isNotEmpty) {
      return localSlides;
    }
    
    // 2. Try local JSON files
    final jsonSlides = await _loadJsonOnboarding(placeId, feature);
    if (jsonSlides.isNotEmpty) {
      await onboardingDao.cacheSlides(jsonSlides, placeId, feature);
      return jsonSlides;
    }
    
    // 3. Fallback to Strapi
    return await _loadFromStrapi(placeId, feature);
  }
}
```

---

## 6. Background Synchronization

### ✅ Implemented

**Background Sync Strategy:**
```dart
class BackgroundSyncService {
  Future<void> syncPlaceContent(String placeId) async {
    if (!await networkInfo.isConnected) return;
    
    try {
      // 1. Check for updates from NestJS API
      final latestVersion = await _getLatestVersion(placeId);
      final currentVersion = await _getCurrentVersion(placeId);
      
      if (latestVersion != currentVersion) {
        // 2. Download updated content
        await assetDownloadService.downloadPlaceAssets(placeId);
        
        // 3. Update local database
        await _updateLocalDatabase(placeId);
      }
    } catch (e) {
      // 4. Fallback to Strapi refresh
      await _refreshFromStrapi(placeId);
    }
  }
}
```

**Periodic Sync:**
```dart
class PeriodicSyncService {
  Timer? _syncTimer;
  
  void startPeriodicSync() {
    _syncTimer = Timer.periodic(Duration(hours: 6), (timer) {
      final placeId = getCurrentPlaceId();
      if (placeId != null) {
        backgroundSyncService.syncPlaceContent(placeId);
      }
    });
  }
  
  void stopPeriodicSync() {
    _syncTimer?.cancel();
  }
}
```

---

## 7. Error Handling & Fallback Strategy

### ✅ Implemented

**Multi-Level Fallback:**
```dart
class ContentFallbackService {
  Future<ContentResult> getContent(String placeId, String contentType) async {
    // Level 1: Local SQLite (fastest)
    try {
      final localContent = await _getFromLocalDatabase(placeId, contentType);
      if (localContent.isNotEmpty) {
        return ContentResult.success(localContent);
      }
    } catch (e) {
      log('Local database error: $e');
    }
    
    // Level 2: Local JSON files
    try {
      final jsonContent = await _getFromLocalJson(placeId, contentType);
      if (jsonContent.isNotEmpty) {
        return ContentResult.success(jsonContent);
      }
    } catch (e) {
      log('Local JSON error: $e');
    }
    
    // Level 3: Strapi backup
    try {
      final strapiContent = await _getFromStrapi(placeId, contentType);
      if (strapiContent.isNotEmpty) {
        return ContentResult.success(strapiContent);
      }
    } catch (e) {
      log('Strapi error: $e');
    }
    
    // Level 4: Default content
    return ContentResult.fallback(_getDefaultContent(contentType));
  }
}
```

**Error Recovery:**
```dart
class ErrorRecoveryService {
  Future<void> handleDownloadError(String placeId, Exception error) async {
    // 1. Log error
    log('Download error for place $placeId: $error');
    
    // 2. Try Strapi fallback
    try {
      await _downloadFromStrapi(placeId);
    } catch (strapiError) {
      // 3. Use cached content if available
      final hasCachedContent = await _checkCachedContent(placeId);
      if (!hasCachedContent) {
        // 4. Show error to user
        _showErrorToUser('Unable to load content. Please check your connection.');
      }
    }
  }
}
```

---

## 8. Deployment & Infrastructure

### ✅ Implemented

**Docker Compose Setup:**
```yaml
# docker-compose.yml
version: '3.8'
services:
  nestjs-api:
    build: ./backend
    ports:
      - "3000:3000"
    environment:
      - MINIO_ENDPOINT=minio
      - MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
      - MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
    depends_on:
      - minio
      - postgres

  minio:
    image: minio/minio
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      - MINIO_ROOT_USER=${MINIO_ROOT_USER}
      - MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}
    volumes:
      - minio_data:/data
    command: server /data --console-address ":9001"

  refine-admin:
    build: ./admin
    ports:
      - "3001:3000"
    environment:
      - API_URL=http://nestjs-api:3000
    depends_on:
      - nestjs-api

  postgres:
    image: postgres:13
    environment:
      - POSTGRES_DB=spacemate
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  minio_data:
  postgres_data:
```

**Hetzner Deployment:**
```bash
# Deploy to Hetzner
docker-compose -f docker-compose.prod.yml up -d

# Setup Cloudflare CDN
# Configure DNS and SSL certificates
# Setup monitoring and logging
```

---

## Implementation Status Summary

### ✅ Fully Implemented
- **NestJS API:** Complete place assets endpoint
- **MinIO Storage:** Object storage for place-specific content
- **Refine.dev Admin:** Content management interface
- **Flutter Integration:** flutter_downloader and file_saver integration
- **Local Storage:** SQLite and file-based caching
- **Background Sync:** Periodic content updates
- **Error Handling:** Multi-level fallback strategy
- **Docker Deployment:** Containerized services on Hetzner

### 🔄 Partially Implemented
- **Content Versioning:** Basic version tracking, advanced versioning pending
- **User Analytics:** Basic usage tracking, detailed analytics pending
- **Admin Features:** Basic CRUD, advanced features pending

### ❌ Not Implemented
- **Real-time Updates:** WebSocket-based live updates
- **Advanced Analytics:** Detailed usage and performance metrics
- **Multi-tenant Features:** Advanced place management features

---

## Recommendations for Completion

### High Priority
1. **Content Versioning:** Implement semantic versioning for place assets
2. **Real-time Updates:** Add WebSocket support for live content updates
3. **Advanced Admin Features:** Bulk operations and content templates

### Medium Priority
1. **Performance Optimization:** Implement content compression and lazy loading
2. **User Analytics:** Track content usage and user behavior
3. **Advanced Error Recovery:** Implement retry strategies and circuit breakers

### Low Priority
1. **Multi-tenant Features:** Advanced place management and permissions
2. **Content Templates:** Pre-built templates for common place types
3. **Advanced Monitoring:** Detailed performance and usage analytics

---

**This new architecture provides a robust offline-first experience with centralized content management, efficient asset delivery, and reliable fallback mechanisms.**