# SpaceMate CMS Architecture

## 1. System Overview

SpaceMate is a multi-tenant CMS for managing menus and onboarding experiences across multiple physical locations. The system is designed with an offline-first approach, where content is cached locally after the initial load.

## 2. URL Structure Options

### Option 1: Tenant-based Subdomain (SaaS Model)
```
{placeId}-{cityCode}.spacemate.xyz
```
**Example:** `google-mtv.spacemate.xyz`

**Pros:**
- Clear tenant separation
- Brandable per location
- Easy to implement DNS-based routing

**Cons:**
- Requires wildcard SSL certificate
- More complex DNS management
- Potential naming conflicts

### Option 2: Path-based (SaaS Model)
```
spacemate.xyz/{placeId}
```
**Example:** `spacemate.xyz/google-mtv`

**Pros:**
- Single SSL certificate
- Simpler DNS management
- Better CDN caching

**Cons:**
- Less brandable per location
- Harder to implement tenant isolation

### Option 3: Client-hosted Subdomain (Self-hosted)
```
spacemate.{clientdomain}.com/{placeId}
```
**Example:** `spacemate.clientcompany.com/google-building1`

**Pros:**
- Client controls DNS
- Clear separation from main domain
- Easier SSL certificate management

**Cons:**
- Requires client DNS configuration
- Harder to update across multiple clients

## 3. Recommended Implementation

### For SaaS Deployment:
```
{slugifiedName}-{locationCode}.spacemate.xyz
```
- **Example:** `google-mtv.spacemate.xyz`
- Uses wildcard DNS and SSL
- Best for managed service offering

### For Client-hosted Deployment:
```
spacemate.{clientdomain}.com/{placeId}
```
- **Example:** `spacemate.clientcompany.com/google-building1`
- Easier client-side DNS management
- Better for enterprise clients with IT policies

## 4. API Endpoints

### Base URL Structure
```
/api/v1/places/{placeId}
```

### Key Endpoints
- `GET /api/v1/places/{placeId}` - Place details
- `GET /api/v1/places/{placeId}/menu` - Full menu structure
- `GET /api/v1/places/{placeId}/onboarding` - Onboarding content
- `GET /api/v1/places/{placeId}/sync` - Get updates since last sync

## 5. Data Flow

1. **Initial Load**:
   - App extracts placeId from URL
   - Checks local cache
   - Fetches from Strapi if needed
   - Caches data locally

2. **Subsequent Loads**:
   - Serves from local cache
   - Background sync if network available

3. **Image Handling**:
   - Lazy-loaded in UI
   - Cached using `cached_network_image`
   - Stored in Cloudflare R2/Firebase Storage

## 6. Strapi Configuration

### Content Types

#### Place
- `slug` (UID, required)
- `displayName` (Text)
- `isActive` (Boolean)
- `config` (JSON)

#### MenuCategory
- `place` (Relation to Place)
- `name` (Text)
- `order` (Number)
- `isActive` (Boolean)

#### MenuItem
- `category` (Relation to MenuCategory)
- `name` (Text)
- `description` (Rich Text)
- `price` (Number)
- `image` (Media)

#### OnboardingScreen
- `place` (Relation to Place)
- `title` (Text)
- `description` (Text)
- `image` (Media)
- `buttonText` (Text)
- `order` (Number)

## 7. Client-Side Implementation

### Dependencies
```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.4
  hydrated_bloc: ^9.1.2
  
  # Network
  dio: ^5.4.0
  cached_network_image: ^3.3.1
  
  # Local Storage
  sqflite: ^2.3.2
  path_provider: ^2.1.1
  
  # Utils
  intl: ^0.20.2
  equatable: ^2.0.5
```

### Folder Structure
```
lib/
  features/
    menu/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
    onboarding/
      # Similar structure as menu
  core/
    config/
    database/
    network/
    theme/
    utils/
```

## 8. Deployment Options

### Option A: Cloud Hosted (SaaS)
- **URL:** `{placeId}.spacemate.xyz`
- **Infrastructure:**
  - Cloudflare for DNS/CDN
  - Strapi on managed Kubernetes/Heroku
  - R2 for media storage

### Option B: Client Hosted
- **URL:** `spacemate.{clientdomain}.com`
- **Infrastructure:**
  - Client-managed DNS
  - Docker container for easy deployment
  - Client's storage solution

## 9. Security Considerations

1. **Authentication**:
   - API keys per client
   - Rate limiting
   - CORS configuration

2. **Data Protection**:
   - Tenant isolation
   - Regular backups
   - Data encryption at rest

3. **Compliance**:
   - GDPR/CCPA ready
   - Data residency options

## 10. Monitoring and Analytics

- Error tracking (Sentry)
- Usage analytics
- Performance monitoring
- Uptime monitoring

## 11. Future Considerations

1. Multi-language support
2. Advanced analytics dashboard
3. Client self-service portal
4. Integration with POS systems
5. Advanced media management

---
*Document Version: 1.0.0*
*Last Updated: 2025-06-22*
