# SpaceMate CMS

A Flutter superapp that provides an offline-first content management system for place-specific menus and onboarding carousels. Built with modern architecture using NestJS backend, MinIO (for admin staging only), Cloudflare CDN (for all client-facing images), Refine.dev administration, and Flutter for the mobile application.

## 🏗️ Architecture Overview

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

## 🚀 Features

### ✅ Offline-First Content Management
- **Local Storage**: Complete offline access to menus, onboarding content, and images
- **Background Sync**: Automatic content updates when online
- **Multi-Level Fallback**: Local SQLite → Local JSON → Strapi → Default content

### ✅ Place-Specific Content
- **Customized Experience**: Each place has its own menus and onboarding carousels
- **Centralized Management**: Refine.dev admin panel for content creation
- **Version Control**: Semantic versioning for content updates

### ✅ Modern Tech Stack
- **Flutter**: Cross-platform mobile app with BLoC state management
- **NestJS**: TypeScript backend API for content delivery
- **MinIO**: Temporary object storage for admin/editor workflows (staging area before images are pushed to Cloudflare CDN)
- **Refine.dev**: React-based admin panel for content management
- **Cloudflare CDN**: Global image hosting and delivery (all client-facing images)

### ✅ Robust Infrastructure
- **Docker Deployment**: Containerized services on Hetzner
- **PostgreSQL**: Metadata storage and management
- **Background Processing**: Non-blocking downloads and updates
- **Error Recovery**: Comprehensive fallback strategies

## 📱 App Features

### Menu System
- **5 Main Screens**: Home, Transport, Access, Facilities, Discover
- **Feature Cards**: Grid layout with Material Design icons and labels
- **Dynamic Content**: Place-specific menu items and features
- **Offline Access**: Works completely offline with cached content

### Onboarding Carousels
- **4-Slide Carousels**: Each feature has a 4-slide onboarding experience
- **Rich Content**: Images, headers, body text, and call-to-action buttons
- **"Don't Show Again"**: User preference tracking for onboarding completion
- **Place-Specific**: Custom onboarding content for each location

### Content Management
- **Refine.dev Admin**: Web-based content management interface
- **Image Upload**: Admin workflow uploads images to MinIO for staging, then pushes to Cloudflare CDN. Only CDN URLs are stored and passed to clients.
- **Version Control**: Track content changes and updates
- **Bulk Operations**: Efficient content management workflows

## 🛠️ Technology Stack

### Frontend (Flutter)
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  sqflite: ^2.3.0
  flutter_downloader: ^1.11.6
  file_saver: ^0.2.8
  path_provider: ^2.1.1
  dio: ^5.3.2
  shared_preferences: ^2.2.2
```

### Backend (NestJS)
```typescript
// Core dependencies
@nestjs/common: ^10.0.0
@nestjs/core: ^10.0.0
@nestjs/typeorm: ^10.0.0
@nestjs/config: ^3.1.1
@nestjs/swagger: ^7.1.16

// Storage
@aws-sdk/client-s3: ^3.450.0
minio: ^7.1.3

// Database
typeorm: ^0.3.17
postgres: ^3.4.3
```

### Admin Panel (Refine.dev)
```typescript
// Core dependencies
@refinedev/core: ^4.45.0
@refinedev/react-hook-form: ^4.8.0
@refinedev/antd: ^5.35.0

// UI Components
antd: ^5.12.8
@ant-design/icons: ^5.2.6
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.16.0+)
- Node.js (18+)
- Docker & Docker Compose
- PostgreSQL
- MinIO

### 1. Clone the Repository
```bash
git clone https://github.com/SpaceMate-XYZ/spacemate_cms.git
cd spacemate_cms
```

### 2. Setup Backend Infrastructure
```bash
# Start Docker services
docker-compose up -d

# Initialize database
docker-compose exec postgres psql -U spacemate -d spacemate -f /docker-entrypoint-initdb.d/init.sql
```

### 3. Configure Environment Variables
```bash
# Copy environment files
cp .env.example .env
cp backend/.env.example backend/.env
cp admin/.env.example admin/.env

# Update with your configuration
nano .env
```

### 4. Start Flutter App
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📁 Project Structure

```
spacemate_cms/
├── lib/
│   ├── core/                 # Core utilities and configurations
│   ├── features/             # Feature modules
│   │   ├── menu/            # Menu system
│   │   ├── onboarding/      # Onboarding carousels
│   │   └── carousel/        # Carousel components
│   └── main.dart
├── backend/                  # NestJS API
│   ├── src/
│   │   ├── controllers/     # API endpoints
│   │   ├── services/        # Business logic
│   │   ├── entities/        # Database models
│   │   └── config/          # Configuration
│   └── docker/
├── admin/                    # Refine.dev admin panel
│   ├── src/
│   │   ├── components/      # UI components
│   │   ├── pages/           # Admin pages
│   │   └── resources/       # API resources
│   └── public/
├── docs/                     # Documentation
├── test/                     # Tests
└── docker-compose.yml        # Infrastructure setup
```

## 🔧 Configuration

### Environment Variables

**Flutter App (.env)**
```env
# API Configuration
API_BASE_URL=https://api.spacemate.xyz
STRAPI_BASE_URL=https://strapi.dev.spacemate.xyz

# Feature Flags
ENABLE_OFFLINE_MODE=true
ENABLE_BACKGROUND_SYNC=true
```

**Backend (.env)**
```env
# Database
DATABASE_URL=postgresql://spacemate:password@localhost:5432/spacemate

# MinIO
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=your-access-key
MINIO_SECRET_KEY=your-secret-key

# Cloudflare
CLOUDFLARE_API_TOKEN=your-api-token
CLOUDFLARE_ZONE_ID=your-zone-id
```

**Admin Panel (.env)**
```env
# API Configuration
REACT_APP_API_URL=http://localhost:3000
REACT_APP_CLOUDINARY_CLOUD_NAME=your-cloud-name
```

## 🧪 Testing

### Flutter Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/features/
```

### Backend Tests
```bash
cd backend
npm test
npm run test:e2e
```

### Admin Panel Tests
```bash
cd admin
npm test
```

### Coverage Goals
- **Initial phase:** >80% code coverage
- **Medium priority:** >95% code coverage across all modules

## 📊 Monitoring & Analytics

### Health Checks
- **API Health**: Monitor NestJS API availability
- **Storage Health**: Monitor MinIO storage status
- **Download Metrics**: Track download success rates
- **Error Tracking**: Comprehensive error logging

### Analytics
- **Usage Metrics**: Track content usage patterns
- **Performance Metrics**: Monitor load times and cache hit rates
- **User Behavior**: Analyze user interaction patterns

## 🔒 Security

### Authentication & Authorization
- **JWT Tokens**: Secure API authentication
- **MinIO Access Control**: IAM-style permissions
- **HTTPS**: All communications encrypted
- **Input Validation**: Comprehensive validation on all inputs

### Data Protection
- **Local Encryption**: Sensitive data encrypted locally
- **Secure Storage**: MinIO with access controls
- **Audit Logging**: Comprehensive activity tracking

## 🚀 Deployment

### Docker Deployment
```bash
# Production deployment
docker-compose -f docker-compose.prod.yml up -d

# Scale services
docker-compose up -d --scale nestjs-api=3
```

### Hetzner Cloud Setup
```bash
# Deploy to Hetzner
docker-compose -f docker-compose.prod.yml up -d

# Setup Cloudflare CDN
# Configure DNS and SSL certificates
# Setup monitoring and logging
```

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines
- Follow **Clean Architecture** principles
- Use **BLoC** for state management
- Write **comprehensive tests**
- Follow **Flutter style guide**
- Document **all public APIs**

## 📚 Documentation

- **[Architecture Guide](docs/architecture.md)** - System architecture overview
- **[Content Schemas](docs/content_schemas.md)** - Data structures and schemas
- **[Offline Strategy](docs/offline_first_content.md)** - Offline-first implementation

### CMS Components

- **[Refine.dev CMS Admin Panel](docs/cms/refine_dev_cms.md)** - Content management interface
- **[MinIO Object Storage](docs/cms/minio_cms.md)** - File storage and management
- **[NestJS CMS API](docs/cms/nest_cms.md)** - Backend API and services
- **[API Documentation](docs/api.md)** - Backend API reference
- **[Admin Guide](docs/admin.md)** - Refine.dev admin panel guide

## 🐛 Troubleshooting

### Common Issues

**Flutter App Issues**
```bash
# Clear cache
flutter clean
flutter pub get

# Reset database
flutter run --dart-define=RESET_DB=true
```

**Backend Issues**
```bash
# Check logs
docker-compose logs nestjs-api

# Restart services
docker-compose restart nestjs-api
```

**Admin Panel Issues**
```bash
# Clear cache
cd admin && npm run clean

# Rebuild
npm run build
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **NestJS Team** for the robust backend framework
- **Refine.dev Team** for the excellent admin panel
- **MinIO Team** for the object storage solution

---

**SpaceMate CMS provides a robust, scalable, and maintainable solution for offline-first content management with centralized administration and efficient asset delivery.**