# MinIO Object Storage CMS

## Overview

MinIO provides high-performance, S3-compatible object storage for SpaceMate CMS, serving as the primary storage backend for images, documents, and other assets. It integrates with Cloudflare CDN for global content delivery and supports offline-first caching strategies.

## Architecture

### Storage Structure
```
spacemate-cms/
├── places/                    # Place-specific assets
│   ├── {place-id}/           # Individual place assets
│   │   ├── images/           # Image assets
│   │   │   ├── onboarding/   # Onboarding carousel images
│   │   │   ├── menus/        # Menu feature images
│   │   │   └── thumbnails/   # Image thumbnails
│   │   ├── documents/        # PDFs, docs
│   │   └── metadata/         # JSON metadata files
│   └── shared/               # Shared assets across places
├── templates/                 # Reusable templates
│   ├── onboarding/           # Onboarding templates
│   └── menus/               # Menu templates
└── system/                   # System assets
    ├── icons/               # App icons
    └── branding/            # Branding assets
```

## Setup & Installation

### Prerequisites
- Docker and Docker Compose
- 50GB+ storage space
- Network access for Cloudflare CDN integration

### Docker Installation

```yaml
# docker-compose.yml
version: '3.8'

services:
  minio:
    image: minio/minio:latest
    container_name: spacemate-minio
    ports:
      - "9000:9000"      # API port
      - "9001:9001"      # Console port
    environment:
      MINIO_ROOT_USER: spacemate-admin
      MINIO_ROOT_PASSWORD: your-secure-password
      MINIO_CONSOLE_ADDRESS: ":9001"
    volumes:
      - minio_data:/data
    command: server /data --console-address ":9001"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 20s
      retries: 3

  minio-client:
    image: minio/mc:latest
    container_name: spacemate-minio-client
    depends_on:
      - minio
    environment:
      MC_HOST_minio: http://spacemate-admin:your-secure-password@minio:9000
    volumes:
      - ./scripts:/scripts
    command: tail -f /dev/null

volumes:
  minio_data:
    driver: local
```

### Manual Installation

```bash
# Download MinIO
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio

# Create data directory
mkdir -p /opt/minio/data

# Start MinIO
./minio server /opt/minio/data --console-address ":9001"
```

## Configuration

### Environment Variables

```bash
# MinIO Configuration
MINIO_ROOT_USER=spacemate-admin
MINIO_ROOT_PASSWORD=your-secure-password
MINIO_CONSOLE_ADDRESS=:9001
MINIO_SERVER_URL=http://localhost:9000

# Cloudflare Integration
CLOUDFLARE_ACCOUNT_ID=your-account-id
CLOUDFLARE_API_TOKEN=your-api-token
CLOUDFLARE_ZONE_ID=your-zone-id

# Backup Configuration
BACKUP_RETENTION_DAYS=30
BACKUP_SCHEDULE=0 2 * * *  # Daily at 2 AM
```

### Bucket Policy Configuration

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["*"]
      },
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::spacemate-cms/*"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["arn:aws:s3:::spacemate-cms"]
      },
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::spacemate-cms/*"
      ]
    }
  ]
}
```

## Bucket Structure

### Initial Setup Script

```bash
#!/bin/bash
# scripts/setup-minio.sh

# Configure MinIO client
mc alias set minio http://localhost:9000 spacemate-admin your-secure-password

# Create main bucket
mc mb minio/spacemate-cms

# Create place-specific buckets
mc mb minio/spacemate-cms-places

# Create system buckets
mc mb minio/spacemate-cms-templates
mc mb minio/spacemate-cms-system

# Set bucket policies
mc policy set download minio/spacemate-cms
mc policy set download minio/spacemate-cms-places
mc policy set download minio/spacemate-cms-templates
mc policy set download minio/spacemate-cms-system

# Enable versioning
mc version enable minio/spacemate-cms
mc version enable minio/spacemate-cms-places

# Set lifecycle policies
mc ilm add minio/spacemate-cms --expiry-days 365
mc ilm add minio/spacemate-cms-places --expiry-days 365

echo "MinIO setup completed successfully!"
```

### Bucket Organization

```typescript
// utils/minio-structure.ts
export const MINIO_BUCKETS = {
  MAIN: 'spacemate-cms',
  PLACES: 'spacemate-cms-places',
  TEMPLATES: 'spacemate-cms-templates',
  SYSTEM: 'spacemate-cms-system'
} as const;

export const MINIO_PATHS = {
  PLACES: {
    IMAGES: 'places/{placeId}/images',
    ONBOARDING: 'places/{placeId}/images/onboarding',
    MENUS: 'places/{placeId}/images/menus',
    THUMBNAILS: 'places/{placeId}/images/thumbnails',
    DOCUMENTS: 'places/{placeId}/documents',
    METADATA: 'places/{placeId}/metadata'
  },
  TEMPLATES: {
    ONBOARDING: 'templates/onboarding',
    MENUS: 'templates/menus'
  },
  SYSTEM: {
    ICONS: 'system/icons',
    BRANDING: 'system/branding'
  }
} as const;
```

## Integration

### NestJS Integration

```typescript
// nestjs/src/minio/minio.service.ts
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as Minio from 'minio';

@Injectable()
export class MinioService {
  private minioClient: Minio.Client;

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

      return `${this.configService.get('MINIO_ENDPOINT')}/${bucketName}/${objectName}`;
    } catch (error) {
      throw new Error(`Failed to upload file: ${error.message}`);
    }
  }

  async downloadFile(bucketName: string, objectName: string): Promise<Buffer> {
    try {
      return await this.minioClient.getObject(bucketName, objectName);
    } catch (error) {
      throw new Error(`Failed to download file: ${error.message}`);
    }
  }

  async deleteFile(bucketName: string, objectName: string): Promise<void> {
    try {
      await this.minioClient.removeObject(bucketName, objectName);
    } catch (error) {
      throw new Error(`Failed to delete file: ${error.message}`);
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
      throw new Error(`Failed to list files: ${error.message}`);
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
      throw new Error(`Failed to generate presigned URL: ${error.message}`);
    }
  }
}
```

### Flutter Integration

```dart
// lib/core/storage/minio_client.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class MinioClient {
  final Dio _dio;
  final String _baseUrl;
  final String _accessKey;
  final String _secretKey;

  MinioClient({
    required String baseUrl,
    required String accessKey,
    required String secretKey,
  }) : _baseUrl = baseUrl,
       _accessKey = accessKey,
       _secretKey = secretKey,
       _dio = Dio();

  Future<String> uploadFile({
    required String bucketName,
    required String objectName,
    required File file,
    String? contentType,
  }) async {
    try {
      final url = '$_baseUrl/$bucketName/$objectName';
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: contentType ?? 'application/octet-stream',
        ),
      });

      await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessKey',
          },
        ),
      );

      return url;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<File> downloadFile({
    required String bucketName,
    required String objectName,
    String? localPath,
  }) async {
    try {
      final url = '$_baseUrl/$bucketName/$objectName';
      
      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer $_accessKey',
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = localPath ?? 
        '${directory.path}/$bucketName/$objectName';
      
      final file = File(filePath);
      await file.create(recursive: true);
      await file.writeAsBytes(response.data);

      return file;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  Future<void> deleteFile({
    required String bucketName,
    required String objectName,
  }) async {
    try {
      final url = '$_baseUrl/$bucketName/$objectName';
      
      await _dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessKey',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  Future<List<String>> listFiles({
    required String bucketName,
    String? prefix,
  }) async {
    try {
      final url = '$_baseUrl/$bucketName';
      final queryParams = prefix != null ? {'prefix': prefix} : null;
      
      final response = await _dio.get(
        url,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessKey',
          },
        ),
      );

      final List<dynamic> objects = response.data['objects'] ?? [];
      return objects.map((obj) => obj['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }
}
```

## Image Processing

### Image Optimization Service

```typescript
// nestjs/src/image-processing/image-processing.service.ts
import { Injectable } from '@nestjs/common';
import * as sharp from 'sharp';
import { MinioService } from '../minio/minio.service';

@Injectable()
export class ImageProcessingService {
  constructor(private minioService: MinioService) {}

  async optimizeImage(
    imageBuffer: Buffer,
    options: {
      width?: number;
      height?: number;
      quality?: number;
      format?: 'jpeg' | 'png' | 'webp';
    } = {}
  ): Promise<Buffer> {
    const {
      width,
      height,
      quality = 80,
      format = 'jpeg'
    } = options;

    let sharpInstance = sharp(imageBuffer);

    if (width || height) {
      sharpInstance = sharpInstance.resize(width, height, {
        fit: 'inside',
        withoutEnlargement: true
      });
    }

    switch (format) {
      case 'jpeg':
        sharpInstance = sharpInstance.jpeg({ quality });
        break;
      case 'png':
        sharpInstance = sharpInstance.png({ quality });
        break;
      case 'webp':
        sharpInstance = sharpInstance.webp({ quality });
        break;
    }

    return await sharpInstance.toBuffer();
  }

  async generateThumbnail(
    imageBuffer: Buffer,
    size: number = 150
  ): Promise<Buffer> {
    return await sharp(imageBuffer)
      .resize(size, size, {
        fit: 'cover',
        position: 'center'
      })
      .jpeg({ quality: 80 })
      .toBuffer();
  }

  async uploadOptimizedImage(
    bucketName: string,
    objectName: string,
    imageBuffer: Buffer,
    options?: {
      width?: number;
      height?: number;
      quality?: number;
      format?: 'jpeg' | 'png' | 'webp';
    }
  ): Promise<string> {
    const optimizedBuffer = await this.optimizeImage(imageBuffer, options);
    return await this.minioService.uploadFile(
      bucketName,
      objectName,
      optimizedBuffer,
      `image/${options?.format || 'jpeg'}`
    );
  }
}
```

## Backup & Recovery

### Backup Script

```bash
#!/bin/bash
# scripts/backup-minio.sh

BACKUP_DIR="/backups/minio"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup all buckets
mc mirror minio/spacemate-cms $BACKUP_DIR/spacemate-cms_$DATE
mc mirror minio/spacemate-cms-places $BACKUP_DIR/spacemate-cms-places_$DATE
mc mirror minio/spacemate-cms-templates $BACKUP_DIR/spacemate-cms-templates_$DATE
mc mirror minio/spacemate-cms-system $BACKUP_DIR/spacemate-cms-system_$DATE

# Compress backups
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz $BACKUP_DIR/*_$DATE

# Clean up old backups
find $BACKUP_DIR -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete
find $BACKUP_DIR -name "*_$DATE" -type d -exec rm -rf {} \;

echo "Backup completed: backup_$DATE.tar.gz"
```

### Recovery Script

```bash
#!/bin/bash
# scripts/restore-minio.sh

BACKUP_FILE=$1
BACKUP_DIR="/backups/minio"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_file>"
    exit 1
fi

# Extract backup
tar -xzf $BACKUP_FILE -C $BACKUP_DIR

# Restore buckets
mc mirror $BACKUP_DIR/spacemate-cms* minio/spacemate-cms
mc mirror $BACKUP_DIR/spacemate-cms-places* minio/spacemate-cms-places
mc mirror $BACKUP_DIR/spacemate-cms-templates* minio/spacemate-cms-templates
mc mirror $BACKUP_DIR/spacemate-cms-system* minio/spacemate-cms-system

echo "Recovery completed successfully"
```

## Monitoring

### Health Check

```typescript
// nestjs/src/health/minio-health.service.ts
import { Injectable } from '@nestjs/common';
import { MinioService } from '../minio/minio.service';

@Injectable()
export class MinioHealthService {
  constructor(private minioService: MinioService) {}

  async checkHealth(): Promise<{
    status: 'healthy' | 'unhealthy';
    details: any;
  }> {
    try {
      // Test basic operations
      const testBucket = 'health-check';
      const testObject = 'test.txt';
      const testData = Buffer.from('health check');

      // Upload test file
      await this.minioService.uploadFile(
        testBucket,
        testObject,
        testData,
        'text/plain'
      );

      // Download test file
      const downloadedData = await this.minioService.downloadFile(
        testBucket,
        testObject
      );

      // Delete test file
      await this.minioService.deleteFile(testBucket, testObject);

      return {
        status: 'healthy',
        details: {
          upload: 'success',
          download: 'success',
          delete: 'success',
          timestamp: new Date().toISOString()
        }
      };
    } catch (error) {
      return {
        status: 'unhealthy',
        details: {
          error: error.message,
          timestamp: new Date().toISOString()
        }
      };
    }
  }
}
```

### Metrics Collection

```typescript
// nestjs/src/metrics/minio-metrics.service.ts
import { Injectable } from '@nestjs/common';
import { MinioService } from '../minio/minio.service';

@Injectable()
export class MinioMetricsService {
  constructor(private minioService: MinioService) {}

  async getStorageMetrics(): Promise<{
    totalSize: number;
    objectCount: number;
    bucketCount: number;
    averageObjectSize: number;
  }> {
    try {
      const buckets = ['spacemate-cms', 'spacemate-cms-places', 'spacemate-cms-templates', 'spacemate-cms-system'];
      let totalSize = 0;
      let totalObjects = 0;

      for (const bucket of buckets) {
        const files = await this.minioService.listFiles(bucket);
        totalObjects += files.length;

        // Calculate total size (simplified)
        totalSize += files.length * 1024; // Approximate
      }

      return {
        totalSize,
        objectCount: totalObjects,
        bucketCount: buckets.length,
        averageObjectSize: totalObjects > 0 ? totalSize / totalObjects : 0
      };
    } catch (error) {
      throw new Error(`Failed to get storage metrics: ${error.message}`);
    }
  }
}
```

## Security

### Access Control

```typescript
// nestjs/src/auth/minio-auth.guard.ts
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

@Injectable()
export class MinioAuthGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const token = request.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return false;
    }

    // Validate token and check permissions
    return this.validateToken(token);
  }

  private validateToken(token: string): boolean {
    // Implement token validation logic
    return true; // Simplified
  }
}
```

### Encryption

```typescript
// nestjs/src/encryption/file-encryption.service.ts
import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';

@Injectable()
export class FileEncryptionService {
  private readonly algorithm = 'aes-256-gcm';
  private readonly key = process.env.ENCRYPTION_KEY || 'default-key-32-chars-long';

  async encryptFile(fileBuffer: Buffer): Promise<{
    encryptedData: Buffer;
    iv: Buffer;
    authTag: Buffer;
  }> {
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipher(this.algorithm, this.key);
    cipher.setAAD(Buffer.from('spacemate-cms', 'utf8'));

    const encryptedData = Buffer.concat([
      cipher.update(fileBuffer),
      cipher.final()
    ]);

    return {
      encryptedData,
      iv,
      authTag: cipher.getAuthTag()
    };
  }

  async decryptFile(
    encryptedData: Buffer,
    iv: Buffer,
    authTag: Buffer
  ): Promise<Buffer> {
    const decipher = crypto.createDecipher(this.algorithm, this.key);
    decipher.setAAD(Buffer.from('spacemate-cms', 'utf8'));
    decipher.setAuthTag(authTag);

    return Buffer.concat([
      decipher.update(encryptedData),
      decipher.final()
    ]);
  }
}
```

## Deployment

### Production Configuration

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  minio:
    image: minio/minio:latest
    container_name: spacemate-minio-prod
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD}
      MINIO_CONSOLE_ADDRESS: ":9001"
    volumes:
      - minio_data:/data
      - /etc/ssl/certs:/etc/ssl/certs:ro
    command: server /data --console-address ":9001"
    restart: unless-stopped
    networks:
      - spacemate-network

  minio-backup:
    image: minio/mc:latest
    container_name: spacemate-minio-backup
    volumes:
      - ./backups:/backups
      - ./scripts:/scripts
    environment:
      MC_HOST_minio: http://${MINIO_ROOT_USER}:${MINIO_ROOT_PASSWORD}@minio:9000
    command: sh -c "while true; do /scripts/backup-minio.sh; sleep 86400; done"
    depends_on:
      - minio
    networks:
      - spacemate-network

volumes:
  minio_data:
    driver: local

networks:
  spacemate-network:
    driver: bridge
```

### SSL Configuration

```bash
#!/bin/bash
# scripts/setup-ssl.sh

# Generate SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout minio.key -out minio.crt \
  -subj "/C=US/ST=State/L=City/O=SpaceMate/CN=minio.spacemate.com"

# Copy certificates
cp minio.crt /etc/ssl/certs/
cp minio.key /etc/ssl/private/

# Set permissions
chmod 644 /etc/ssl/certs/minio.crt
chmod 600 /etc/ssl/private/minio.key

echo "SSL certificates configured successfully"
```

---

**This MinIO CMS configuration provides robust, scalable object storage for SpaceMate CMS with comprehensive backup, monitoring, and security features.** 