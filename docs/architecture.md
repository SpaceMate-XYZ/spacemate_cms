# SpaceMate CMS Architecture

## Overview

SpaceMate CMS is a Flutter superapp that provides an offline-first content management system for place-specific menus and onboarding carousels. The app uses a modern architecture with NestJS backend, MinIO storage, Refine.dev administration, and Flutter for the mobile application.

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Flutter Mobile App                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   flutter_  │  │   file_     │  │   SQLite    │          │
│  │ downloader  │  │   saver     │  │   Local DB  │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    NestJS Backend API                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │ placeApp    │  │   MinIO     │  │  Cloudflare │          │
│  │ Assets API  │  │   Storage   │  │     CDN     │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Refine.dev Admin Panel                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   Content   │  │   Image     │  │   Place     │          │
│  │   Editor    │  │  Uploader   │  │ Management  │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

### Data Flow

1. **Content Creation**: Admin users create place-specific content via Refine.dev
2. **Storage**: Content is stored in MinIO with metadata in PostgreSQL
3. **API Delivery**: NestJS API serves place assets to Flutter app
4. **Download**: Flutter app downloads assets using flutter_downloader
5. **Local Storage**: Assets are stored locally using file_saver and SQLite
6. **Offline Access**: App works completely offline with cached content
7. **Background Sync**: Periodic updates from NestJS API with Strapi fallback

## Backend Infrastructure

### NestJS API (`placeAppAssets`)

**Purpose**: Serve place-specific content to Flutter apps

**Key Endpoints**:
- `GET /place-app-assets/:placeId` - Get all assets for a place
- `GET /place-app-assets/:placeId/version` - Get current version
- `POST /place-app-assets/:placeId/sync` - Trigger sync

**Response Format**:
```json
{
  "placeId": "place-001",
  "menus": { /* menu data */ },
  "onboarding": { /* onboarding data */ },
  "images": [ /* image metadata */ ],
  "metadata": {
    "version": "1.2.0",
    "lastUpdated": "2024-01-15T10:30:00Z",
    "totalSize": 5242880
  }
}
```

**Documentation**: See [NestJS CMS API](cms/nest_cms.md) for detailed setup and API documentation.

### MinIO Storage

**Purpose**: Object storage for place-specific assets

**Structure**:
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

**Documentation**: See [MinIO Object Storage](cms/minio_cms.md) for detailed setup and configuration.

### Refine.dev Admin Panel

**Purpose**: Content management interface

**Features**:
- Place management (CRUD operations)
- Menu content editor
- Onboarding carousel editor
- Image upload and management
- Version control and publishing

**Documentation**: See [Refine.dev CMS Admin Panel](cms/refine_dev_cms.md) for detailed setup and usage.

## Flutter App Architecture

### Core Components

**Asset Download Service**:
```dart
class AssetDownloadService {
  Future<void> downloadPlaceAssets(String placeId) async {
    // 1. Fetch from NestJS API
    // 2. Download images with flutter_downloader
    // 3. Store JSON with file_saver
    // 4. Update SQLite database
  }
}
```

**Content Loading Strategy**:
```dart
class ContentLoadingService {
  Future<List<MenuScreen>> loadMenus(String placeId) async {
    // 1. Try local SQLite
    // 2. Try local JSON files
    // 3. Fallback to Strapi
  }
}
```

### Local Storage

**SQLite Schema**:
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
  asset_type TEXT NOT NULL,
  asset_key TEXT NOT NULL,
  asset_data TEXT NOT NULL,
  local_path TEXT,
  file_size INTEGER,
  cached_at INTEGER NOT NULL,
  FOREIGN KEY (place_id) REFERENCES places(id)
);
```

## Deployment Architecture

### Docker Compose Setup

```yaml
version: '3.8'
services:
  nestjs-api:
    build: ./backend
    ports: ["3000:3000"]
    environment:
      - MINIO_ENDPOINT=minio
      - MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
      - MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
    depends_on: [minio, postgres]

  minio:
    image: minio/minio
    ports: ["9000:9000", "9001:9001"]
    environment:
      - MINIO_ROOT_USER=${MINIO_ROOT_USER}
      - MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}
    volumes: [minio_data:/data]

  refine-admin:
    build: ./admin
    ports: ["3001:3000"]
    environment:
      - API_URL=http://nestjs-api:3000
    depends_on: [nestjs-api]

  postgres:
    image: postgres:13
    environment:
      - POSTGRES_DB=spacemate
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes: [postgres_data:/var/lib/postgresql/data]
```

### Infrastructure Components

- **Hetzner Cloud**: Hosting for Docker containers
- **Cloudflare CDN**: Image hosting and delivery
- **PostgreSQL**: Metadata storage
- **MinIO**: Object storage for assets

## Offline-First Strategy

### Multi-Level Fallback

1. **Local SQLite**: Fastest access to cached content
2. **Local JSON Files**: File-based storage for large datasets
3. **Strapi Backup**: Legacy system for content refresh
4. **Default Content**: Built-in fallback content

### Background Synchronization

- **Periodic Sync**: Every 6 hours check for updates
- **Version Checking**: Compare local vs remote versions
- **Incremental Updates**: Download only changed content
- **Error Recovery**: Fallback to Strapi on API failures

## Security & Performance

### Security Measures

- **API Authentication**: JWT tokens for NestJS API
- **MinIO Access Control**: IAM-style permissions
- **HTTPS**: All communications encrypted
- **Input Validation**: Comprehensive validation on all inputs

### Performance Optimizations

- **CDN Delivery**: Cloudflare for global image delivery
- **Compression**: Gzip compression for API responses
- **Caching**: Multiple layers of caching (CDN, local, SQLite)
- **Lazy Loading**: Load content on demand
- **Background Processing**: Non-blocking downloads

## Monitoring & Analytics

### Health Checks

- **API Health**: Monitor NestJS API availability
- **Storage Health**: Monitor MinIO storage status
- **Download Metrics**: Track download success rates
- **Error Tracking**: Comprehensive error logging

### Analytics

- **Usage Metrics**: Track content usage patterns
- **Performance Metrics**: Monitor load times and cache hit rates
- **User Behavior**: Analyze user interaction patterns

## Future Enhancements

### Planned Features

1. **Real-time Updates**: WebSocket-based live content updates
2. **Advanced Analytics**: Detailed usage and performance metrics
3. **Multi-tenant Features**: Advanced place management
4. **Content Templates**: Pre-built templates for common place types
5. **Advanced Monitoring**: Detailed performance and usage analytics

### Technical Debt

1. **Content Versioning**: Implement semantic versioning
2. **Retry Strategies**: Implement exponential backoff
3. **Circuit Breakers**: Add resilience patterns
4. **Advanced Caching**: Implement more sophisticated caching strategies

---

**This architecture provides a robust, scalable, and maintainable solution for offline-first content management with centralized administration and efficient asset delivery.**
