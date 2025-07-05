# NestJS CMS API

## Overview

The NestJS CMS API serves as the backend for SpaceMate CMS, providing RESTful endpoints for content management, asset handling, and integration with MinIO storage and Cloudflare CDN.

## Architecture

### Project Structure
```
nestjs-cms/
├── src/
│   ├── main.ts                 # Application entry point
│   ├── app.module.ts           # Root module
│   ├── app.controller.ts       # Health check endpoints
│   ├── config/                 # Configuration management
│   ├── modules/
│   │   ├── places/            # Place management
│   │   ├── assets/            # Asset management
│   │   ├── onboarding/        # Onboarding content
│   │   ├── menus/             # Menu content
│   │   └── sync/              # Synchronization
│   ├── shared/
│   │   ├── decorators/        # Custom decorators
│   │   ├── filters/           # Exception filters
│   │   ├── guards/            # Authentication guards
│   │   ├── interceptors/      # Request/response interceptors
│   │   └── pipes/             # Validation pipes
│   ├── database/
│   │   ├── entities/          # TypeORM entities
│   │   ├── migrations/        # Database migrations
│   │   └── seeds/             # Database seeds
│   └── utils/
│       ├── minio-client.ts    # MinIO integration
│       ├── cloudflare.ts      # Cloudflare CDN integration
│       └── encryption.ts      # File encryption utilities
├── test/                      # Test files
├── docker/                    # Docker configuration
└── package.json
```

## Setup & Installation

### Prerequisites
- Node.js (18+)
- PostgreSQL (13+)
- Redis (6+)
- MinIO server
- Docker and Docker Compose

### Installation

```bash
# Clone the repository
git clone https://github.com/SpaceMate-XYZ/nestjs-cms.git
cd nestjs-cms

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
```

### Environment Configuration

```env
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api/v1

# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=spacemate
DATABASE_PASSWORD=your-password
DATABASE_NAME=spacemate_cms

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# MinIO
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_USE_SSL=false
MINIO_ACCESS_KEY=spacemate-admin
MINIO_SECRET_KEY=your-secure-password
MINIO_BUCKET_NAME=spacemate-cms

# Cloudflare
CLOUDFLARE_ACCOUNT_ID=your-account-id
CLOUDFLARE_API_TOKEN=your-api-token
CLOUDFLARE_ZONE_ID=your-zone-id
CLOUDFLARE_DOMAIN=cdn.spacemate.com

# JWT
JWT_SECRET=your-jwt-secret
JWT_EXPIRES_IN=7d

# Rate Limiting
THROTTLE_TTL=60
THROTTLE_LIMIT=100

# Logging
LOG_LEVEL=info
LOG_FORMAT=combined
```

## Dependencies

### Core Dependencies
```json
{
  "@nestjs/common": "^10.0.0",
  "@nestjs/core": "^10.0.0",
  "@nestjs/platform-express": "^10.0.0",
  "@nestjs/typeorm": "^10.0.0",
  "@nestjs/config": "^3.0.0",
  "@nestjs/jwt": "^10.0.0",
  "@nestjs/throttler": "^5.0.0",
  "@nestjs/swagger": "^7.0.0",
  "typeorm": "^0.3.0",
  "pg": "^8.11.0",
  "redis": "^4.6.0",
  "class-validator": "^0.14.0",
  "class-transformer": "^0.5.1"
}
```

### Storage & CDN
```json
{
  "minio": "^7.1.0",
  "sharp": "^0.32.0",
  "multer": "^1.4.5",
  "@types/multer": "^1.4.7"
}
```

### Utilities
```json
{
  "uuid": "^9.0.0",
  "crypto": "^1.0.1",
  "compression": "^1.7.4",
  "helmet": "^7.0.0"
}
```

## Modules

### Places Module

```typescript
// src/modules/places/places.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PlacesController } from './places.controller';
import { PlacesService } from './places.service';
import { Place } from './entities/place.entity';
import { MinioService } from '../../shared/services/minio.service';
import { CloudflareService } from '../../shared/services/cloudflare.service';

@Module({
  imports: [TypeOrmModule.forFeature([Place])],
  controllers: [PlacesController],
  providers: [PlacesService, MinioService, CloudflareService],
  exports: [PlacesService],
})
export class PlacesModule {}
```

```typescript
// src/modules/places/entities/place.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { Menu } from '../../menus/entities/menu.entity';
import { OnboardingCarousel } from '../../onboarding/entities/onboarding-carousel.entity';

@Entity('places')
export class Place {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  placeId: string;

  @Column()
  name: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ nullable: true })
  location: string;

  @Column({ default: '1.0.0' })
  version: string;

  @Column({ type: 'jsonb', default: [] })
  features: string[];

  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any>;

  @OneToMany(() => Menu, menu => menu.place)
  menus: Menu[];

  @OneToMany(() => OnboardingCarousel, carousel => carousel.place)
  onboardingCarousels: OnboardingCarousel[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

```typescript
// src/modules/places/places.controller.ts
import { Controller, Get, Post, Put, Delete, Body, Param, Query, UseInterceptors, UploadedFiles } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiConsumes } from '@nestjs/swagger';
import { FilesInterceptor } from '@nestjs/platform-express';
import { PlacesService } from './places.service';
import { CreatePlaceDto, UpdatePlaceDto, PlaceResponseDto } from './dto';
import { PaginationDto } from '../../shared/dto/pagination.dto';

@ApiTags('Places')
@Controller('places')
export class PlacesController {
  constructor(private readonly placesService: PlacesService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new place' })
  @ApiResponse({ status: 201, description: 'Place created successfully', type: PlaceResponseDto })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FilesInterceptor('images'))
  async createPlace(
    @Body() createPlaceDto: CreatePlaceDto,
    @UploadedFiles() images?: Express.Multer.File[]
  ): Promise<PlaceResponseDto> {
    return this.placesService.create(createPlaceDto, images);
  }

  @Get()
  @ApiOperation({ summary: 'Get all places with pagination' })
  @ApiResponse({ status: 200, description: 'Places retrieved successfully', type: [PlaceResponseDto] })
  async getAllPlaces(@Query() paginationDto: PaginationDto): Promise<{
    data: PlaceResponseDto[];
    total: number;
    page: number;
    limit: number;
  }> {
    return this.placesService.findAll(paginationDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get place by ID' })
  @ApiResponse({ status: 200, description: 'Place retrieved successfully', type: PlaceResponseDto })
  async getPlaceById(@Param('id') id: string): Promise<PlaceResponseDto> {
    return this.placesService.findById(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update place by ID' })
  @ApiResponse({ status: 200, description: 'Place updated successfully', type: PlaceResponseDto })
  async updatePlace(
    @Param('id') id: string,
    @Body() updatePlaceDto: UpdatePlaceDto
  ): Promise<PlaceResponseDto> {
    return this.placesService.update(id, updatePlaceDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete place by ID' })
  @ApiResponse({ status: 200, description: 'Place deleted successfully' })
  async deletePlace(@Param('id') id: string): Promise<void> {
    return this.placesService.delete(id);
  }

  @Get(':id/assets')
  @ApiOperation({ summary: 'Get place assets' })
  @ApiResponse({ status: 200, description: 'Assets retrieved successfully' })
  async getPlaceAssets(@Param('id') id: string): Promise<{
    images: string[];
    documents: string[];
    metadata: Record<string, any>;
  }> {
    return this.placesService.getAssets(id);
  }

  @Post(':id/sync')
  @ApiOperation({ summary: 'Sync place with Flutter app' })
  @ApiResponse({ status: 200, description: 'Sync completed successfully' })
  async syncPlace(@Param('id') id: string): Promise<{
    status: string;
    message: string;
    timestamp: Date;
  }> {
    return this.placesService.syncWithFlutterApp(id);
  }
}
```

## Shared Services

### MinIO Service

```typescript
// src/shared/services/minio.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as Minio from 'minio';

@Injectable()
export class MinioService {
  private readonly minioClient: Minio.Client;
  private readonly logger = new Logger(MinioService.name);

  constructor(private configService: ConfigService) {
    this.minioClient = new Minio.Client({
      endPoint: this.configService.get('MINIO_ENDPOINT'),
      port: parseInt(this.configService.get('MINIO_PORT')),
      useSSL: this.configService.get('MINIO_USE_SSL') === 'true',
      accessKey: this.configService.get('MINIO_ACCESS_KEY'),
      secretKey: this.configService.get('MINIO_SECRET_KEY'),
    });
  }

  async uploadFile(
    bucketName: string,
    objectName: string,
    file: Buffer,
    contentType?: string
  ): Promise<string> {
    try {
      await this.minioClient.putObject(
        bucketName,
        objectName,
        file,
        file.length,
        { 'Content-Type': contentType || 'application/octet-stream' }
      );

      const url = `${this.configService.get('MINIO_ENDPOINT')}/${bucketName}/${objectName}`;
      this.logger.log(`File uploaded: ${url}`);
      
      return url;
    } catch (error) {
      this.logger.error(`Failed to upload file: ${error.message}`);
      throw error;
    }
  }

  async downloadFile(bucketName: string, objectName: string): Promise<Buffer> {
    try {
      return await this.minioClient.getObject(bucketName, objectName);
    } catch (error) {
      this.logger.error(`Failed to download file: ${error.message}`);
      throw error;
    }
  }

  async deleteFile(bucketName: string, objectName: string): Promise<void> {
    try {
      await this.minioClient.removeObject(bucketName, objectName);
      this.logger.log(`File deleted: ${bucketName}/${objectName}`);
    } catch (error) {
      this.logger.error(`Failed to delete file: ${error.message}`);
      throw error;
    }
  }

  async listFiles(bucketName: string, prefix?: string): Promise<string[]> {
    try {
      const objectsStream = this.minioClient.listObjects(bucketName, prefix, true);
      const files: string[] = [];

      return new Promise((resolve, reject) => {
        objectsStream.on('data', (obj) => {
          files.push(obj.name);
        });
        objectsStream.on('error', reject);
        objectsStream.on('end', () => resolve(files));
      });
    } catch (error) {
      this.logger.error(`Failed to list files: ${error.message}`);
      throw error;
    }
  }

  async generatePresignedUrl(
    bucketName: string,
    objectName: string,
    expirySeconds: number = 3600
  ): Promise<string> {
    try {
      return await this.minioClient.presignedGetObject(
        bucketName,
        objectName,
        expirySeconds
      );
    } catch (error) {
      this.logger.error(`Failed to generate presigned URL: ${error.message}`);
      throw error;
    }
  }
}
```

### Cloudflare Service

```typescript
// src/shared/services/cloudflare.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';

@Injectable()
export class CloudflareService {
  private readonly logger = new Logger(CloudflareService.name);
  private readonly apiToken: string;
  private readonly accountId: string;
  private readonly zoneId: string;
  private readonly domain: string;

  constructor(private configService: ConfigService) {
    this.apiToken = this.configService.get('CLOUDFLARE_API_TOKEN');
    this.accountId = this.configService.get('CLOUDFLARE_ACCOUNT_ID');
    this.zoneId = this.configService.get('CLOUDFLARE_ZONE_ID');
    this.domain = this.configService.get('CLOUDFLARE_DOMAIN');
  }

  async createCache(path: string): Promise<void> {
    try {
      const url = `https://api.cloudflare.com/client/v4/zones/${this.zoneId}/purge_cache`;
      
      await axios.post(url, {
        files: [`https://${this.domain}/${path}`]
      }, {
        headers: {
          'Authorization': `Bearer ${this.apiToken}`,
          'Content-Type': 'application/json'
        }
      });

      this.logger.log(`Cache created for: ${path}`);
    } catch (error) {
      this.logger.error(`Failed to create cache: ${error.message}`);
      throw error;
    }
  }

  async updateCache(path: string): Promise<void> {
    try {
      const url = `https://api.cloudflare.com/client/v4/zones/${this.zoneId}/purge_cache`;
      
      await axios.post(url, {
        files: [`https://${this.domain}/${path}`]
      }, {
        headers: {
          'Authorization': `Bearer ${this.apiToken}`,
          'Content-Type': 'application/json'
        }
      });

      this.logger.log(`Cache updated for: ${path}`);
    } catch (error) {
      this.logger.error(`Failed to update cache: ${error.message}`);
      throw error;
    }
  }

  async deleteCache(path: string): Promise<void> {
    try {
      const url = `https://api.cloudflare.com/client/v4/zones/${this.zoneId}/purge_cache`;
      
      await axios.post(url, {
        files: [`https://${this.domain}/${path}`]
      }, {
        headers: {
          'Authorization': `Bearer ${this.apiToken}`,
          'Content-Type': 'application/json'
        }
      });

      this.logger.log(`Cache deleted for: ${path}`);
    } catch (error) {
      this.logger.error(`Failed to delete cache: ${error.message}`);
      throw error;
    }
  }

  async uploadSyncPackage(placeId: string, packageData: Buffer): Promise<string> {
    try {
      const url = `https://api.cloudflare.com/client/v4/accounts/${this.accountId}/storage/buckets/sync-packages/objects/${placeId}.json`;
      
      const response = await axios.put(url, packageData, {
        headers: {
          'Authorization': `Bearer ${this.apiToken}`,
          'Content-Type': 'application/json'
        }
      });

      this.logger.log(`Sync package uploaded for place: ${placeId}`);
      return response.data.result.id;
    } catch (error) {
      this.logger.error(`Failed to upload sync package: ${error.message}`);
      throw error;
    }
  }
}
```

## Deployment

### Docker Configuration

```dockerfile
# Dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY . .

# Build application
RUN npm run build

# Expose port
EXPOSE 3000

# Start application
CMD ["npm", "run", "start:prod"]
```

### Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  nestjs-api:
    build: .
    container_name: spacemate-nestjs-api
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_HOST=postgres
      - REDIS_HOST=redis
      - MINIO_ENDPOINT=minio
    depends_on:
      - postgres
      - redis
      - minio
    networks:
      - spacemate-network
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    container_name: spacemate-postgres
    environment:
      POSTGRES_DB: spacemate_cms
      POSTGRES_USER: spacemate
      POSTGRES_PASSWORD: your-secure-password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - spacemate-network

  redis:
    image: redis:7-alpine
    container_name: spacemate-redis
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - spacemate-network

  minio:
    image: minio/minio:latest
    container_name: spacemate-minio
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: spacemate-admin
      MINIO_ROOT_PASSWORD: your-secure-password
    volumes:
      - minio_data:/data
    command: server /data --console-address ":9001"
    networks:
      - spacemate-network

volumes:
  postgres_data:
  redis_data:
  minio_data:

networks:
  spacemate-network:
    driver: bridge
```

## Testing

### Unit Tests

```typescript
// src/modules/places/places.service.spec.ts
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PlacesService } from './places.service';
import { Place } from './entities/place.entity';
import { MinioService } from '../../shared/services/minio.service';
import { CloudflareService } from '../../shared/services/cloudflare.service';

describe('PlacesService', () => {
  let service: PlacesService;
  let repository: Repository<Place>;
  let minioService: MinioService;
  let cloudflareService: CloudflareService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PlacesService,
        {
          provide: getRepositoryToken(Place),
          useValue: {
            create: jest.fn(),
            save: jest.fn(),
            findOne: jest.fn(),
            findAndCount: jest.fn(),
            remove: jest.fn(),
          },
        },
        {
          provide: MinioService,
          useValue: {
            uploadFile: jest.fn(),
            deleteBucket: jest.fn(),
            listFiles: jest.fn(),
          },
        },
        {
          provide: CloudflareService,
          useValue: {
            createCache: jest.fn(),
            updateCache: jest.fn(),
            deleteCache: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<PlacesService>(PlacesService);
    repository = module.get<Repository<Place>>(getRepositoryToken(Place));
    minioService = module.get<MinioService>(MinioService);
    cloudflareService = module.get<CloudflareService>(CloudflareService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should create a new place', async () => {
      const createPlaceDto = {
        placeId: 'test-place-001',
        name: 'Test Place',
        description: 'Test description',
        location: 'Test location',
        features: ['parking', 'meeting'],
        metadata: { test: 'data' },
      };

      const mockPlace = {
        id: 'uuid',
        ...createPlaceDto,
        version: '1.0.0',
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      jest.spyOn(repository, 'findOne').mockResolvedValue(null);
      jest.spyOn(repository, 'create').mockReturnValue(mockPlace as Place);
      jest.spyOn(repository, 'save').mockResolvedValue(mockPlace as Place);
      jest.spyOn(minioService, 'uploadFile').mockResolvedValue('url');
      jest.spyOn(cloudflareService, 'createCache').mockResolvedValue();

      const result = await service.create(createPlaceDto);

      expect(result.placeId).toBe(createPlaceDto.placeId);
      expect(result.name).toBe(createPlaceDto.name);
      expect(repository.save).toHaveBeenCalled();
      expect(cloudflareService.createCache).toHaveBeenCalled();
    });

    it('should throw error if place already exists', async () => {
      const createPlaceDto = {
        placeId: 'existing-place',
        name: 'Test Place',
      };

      jest.spyOn(repository, 'findOne').mockResolvedValue({} as Place);

      await expect(service.create(createPlaceDto)).rejects.toThrow(
        'Place with ID existing-place already exists'
      );
    });
  });
});
```

### Integration Tests

```typescript
// test/places.e2e-spec.ts
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Places (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('/places (POST)', () => {
    return request(app.getHttpServer())
      .post('/places')
      .send({
        placeId: 'test-place-001',
        name: 'Test Place',
        description: 'Test description',
        location: 'Test location',
        features: ['parking', 'meeting'],
      })
      .expect(201)
      .expect((res) => {
        expect(res.body.placeId).toBe('test-place-001');
        expect(res.body.name).toBe('Test Place');
      });
  });

  it('/places (GET)', () => {
    return request(app.getHttpServer())
      .get('/places')
      .expect(200)
      .expect((res) => {
        expect(Array.isArray(res.body.data)).toBe(true);
        expect(typeof res.body.total).toBe('number');
      });
  });
});
```

## Monitoring

### Health Check

```typescript
// src/app.controller.ts
import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { HealthService } from './health/health.service';

@ApiTags('Health')
@Controller()
export class AppController {
  constructor(private readonly healthService: HealthService) {}

  @Get('health')
  @ApiOperation({ summary: 'Health check endpoint' })
  @ApiResponse({ status: 200, description: 'Service is healthy' })
  async getHealth(): Promise<{
    status: string;
    timestamp: string;
    uptime: number;
    version: string;
  }> {
    return this.healthService.check();
  }

  @Get('ready')
  @ApiOperation({ summary: 'Readiness check endpoint' })
  @ApiResponse({ status: 200, description: 'Service is ready' })
  async getReadiness(): Promise<{
    status: string;
    database: string;
    redis: string;
    minio: string;
  }> {
    return this.healthService.checkReadiness();
  }
}
```

### Metrics Collection

```typescript
// src/metrics/metrics.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Place } from '../modules/places/entities/place.entity';

@Injectable()
export class MetricsService {
  constructor(
    @InjectRepository(Place)
    private placeRepository: Repository<Place>,
  ) {}

  async getMetrics(): Promise<{
    totalPlaces: number;
    activePlaces: number;
    totalAssets: number;
    storageUsed: number;
    lastSync: Date;
  }> {
    const totalPlaces = await this.placeRepository.count();
    const activePlaces = await this.placeRepository.count({
      where: { version: '1.0.0' },
    });

    return {
      totalPlaces,
      activePlaces,
      totalAssets: 0, // Calculate from MinIO
      storageUsed: 0, // Calculate from MinIO
      lastSync: new Date(),
    };
  }
}
```

---

**This NestJS CMS API provides a robust, scalable backend for SpaceMate CMS with comprehensive content management, asset handling, and synchronization capabilities.** 