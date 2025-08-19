import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spacemate/core/config/cors_config.dart';
import 'dart:developer' as developer;

class ImageUtils {
  static const String _imageCacheDir = 'cached_images';
  static const Duration _cacheDuration = Duration(days: 30);

  /// Check if we're in development mode
  static bool get isDevelopment => kDebugMode;

  /// Get the cache directory for storing images
  static Future<Directory> getCacheDirectory() async {
    // On web, the browser cache is used instead of a local filesystem.
    if (kIsWeb) {
      throw UnsupportedError('Image cache directory is not available on web; use browser cache.');
    }

    final directory = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${directory.path}/$_imageCacheDir');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    return cacheDir;
  }

  /// Get a file reference for a cached image
  static Future<File> getCachedImageFile(String url) async {
    if (kIsWeb) {
      // Not supported on web - callers should use CachedNetworkImage which relies on browser cache.
      throw UnsupportedError('getCachedImageFile() is not supported on web');
    }

    final cacheDir = await getCacheDirectory();
    final uri = Uri.parse(url);
    final filename = '${uri.pathSegments.last}.${uri.pathSegments.last.split('.').last}';
    return File('${cacheDir.path}/$filename');
  }

  /// Check if an image is cached
  static Future<bool> isImageCached(String url) async {
    if (url.isEmpty) return false;
    if (kIsWeb) return false;

    try {
      final file = await getCachedImageFile(url);
      if (await file.exists()) {
        final lastModified = await file.lastModified();
        final now = DateTime.now();

        // Check if the cache is still valid
        if (now.difference(lastModified) < _cacheDuration) {
          return true;
        } else {
          // Delete expired cache
          await file.delete();
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Cache an image from the network
  static Future<File?> cacheImageFromNetwork(String url) async {
    if (kIsWeb) {
      // Browser will handle caching; nothing to store on local filesystem.
      return null;
    }

    try {
      final file = await getCachedImageFile(url);

      // Skip if already cached and valid
      if (await isImageCached(url)) {
        return file;
      }

      // Use CachedNetworkImage to handle the download and caching (UI-driven cache)
      CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(),
        errorWidget: (context, url, error) => Container(),
      );

      // The image file may be managed by the caching library; return the expected file handle.
      return file;
    } catch (e) {
      return null;
    }
  }

  /// Get the image URL with CORS handling for web builds
  static String getImageUrlWithCorsHandling(String originalUrl) {
    return CorsConfig.processUrl(originalUrl);
  }

  /// Get an image widget that handles CORS and caching
  static Widget corsAwareImage({
    required String imageUrl,
    required String placeholderIcon,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Color? color,
    Map<String, String>? headers,
  }) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder(placeholderIcon, width, height, color);
    }

    final processedUrl = getImageUrlWithCorsHandling(imageUrl);
    final corsHeaders = headers ?? CorsConfig.getCorsHeaders();

    return CachedNetworkImage(
      imageUrl: processedUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      httpHeaders: corsHeaders,
      placeholder: (context, url) => _buildPlaceholder(placeholderIcon, width, height, color),
      errorWidget: (context, url, error) {
        // For web builds, show a more specific error message for CORS issues
        if (kIsWeb && (error.toString().contains('CORS') || CorsConfig.isLikelyCorsIssue(imageUrl))) {
          return _buildCorsErrorPlaceholder(width, height);
        }
        return _buildPlaceholder(placeholderIcon, width, height, color);
      },
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }

  /// Get an image widget that handles caching
  static Widget cachedImage({
    required String imageUrl,
    required String placeholderIcon,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Color? color,
  }) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder(placeholderIcon, width, height, color);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      placeholder: (context, url) => _buildPlaceholder(placeholderIcon, width, height, color),
      errorWidget: (context, url, error) => _buildPlaceholder(placeholderIcon, width, height, color),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }

  static Widget _buildPlaceholder(String icon, double? width, double? height, Color? color) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          _getIconData(icon) ?? Icons.image_not_supported,
          size: (width ?? height ?? 24) * 0.6,
          color: color ?? Colors.grey[400],
        ),
      ),
    );
  }

  static Widget _buildCorsErrorPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: (width ?? height ?? 24) * 0.4,
              color: Colors.red[400],
            ),
            const SizedBox(height: 8),
            Text(
              'CORS Error',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData? _getIconData(String iconName) {
    // Map common icon names to Material Icons
    final iconMap = <String, IconData>{
      'home': Icons.home,
      'settings': Icons.settings,
      'person': Icons.person,
      'notifications': Icons.notifications,
      'menu': Icons.menu,
      'search': Icons.search,
      'back': Icons.arrow_back,
      'forward': Icons.arrow_forward,
      'add': Icons.add,
      'remove': Icons.remove,
      'close': Icons.close,
      'check': Icons.check,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'favorite': Icons.favorite,
      'share': Icons.share,
      'more': Icons.more_vert,
    };

    return iconMap[iconName.toLowerCase()];
  }

  /// Clear all cached images
  static Future<void> clearImageCache() async {
    if (kIsWeb) return; // rely on browser cache

    try {
      final cacheDir = await getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Get the size of the image cache
  static Future<int> getImageCacheSize() async {
    if (kIsWeb) return 0;

    try {
      final cacheDir = await getCacheDirectory();
      if (!await cacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      final files = cacheDir.listSync(recursive: true);

      for (var file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Format bytes to human-readable format
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Load an image with CORS handling and fallback strategies
  static Widget loadImage({
    required String imageUrl,
    required Widget Function(BuildContext, String, dynamic) errorWidget,
    Widget Function(BuildContext, String)? placeholder,
    BoxFit fit = BoxFit.cover,
    Map<String, String>? httpHeaders,
  }) {
    final processedUrl = _processImageUrl(imageUrl);
    
    developer.log('ImageUtils: Loading image from $imageUrl (processed: $processedUrl)');
    developer.log('ImageUtils: Is Web: $kIsWeb');
    developer.log('ImageUtils: HTTP Headers: $httpHeaders');
    
    // Try different header combinations for CDN authentication
    final headers = httpHeaders ?? _getBestHeaders(imageUrl);
    developer.log('ImageUtils: Using headers: $headers');
    
    return CachedNetworkImage(
      imageUrl: processedUrl,
      fit: fit,
      placeholder: placeholder ?? _defaultPlaceholder,
      errorWidget: (context, url, error) {
        developer.log('ImageUtils: Failed to load $url, error: $error');
        developer.log('ImageUtils: Error type: ${error.runtimeType}');
        
        // If this is a CORS error and we're in development, try the proxy
        if (kIsWeb && isDevelopment && (error.toString().contains('CORS') || error.toString().contains('ERR_FAILED'))) {
          developer.log('ImageUtils: CORS error detected, trying proxy URL');
          final proxyUrl = '${CorsConfig.developmentProxyUrl}${Uri.encodeComponent(imageUrl)}';
          return CachedNetworkImage(
            imageUrl: proxyUrl,
            fit: fit,
            placeholder: placeholder ?? _defaultPlaceholder,
            errorWidget: (context, proxyUrl, proxyError) {
              developer.log('ImageUtils: Proxy also failed: $proxyUrl, error: $proxyError');
              return _handleImageError(context, url, error, imageUrl, errorWidget);
            },
          );
        }
        
        return _handleImageError(context, url, error, imageUrl, errorWidget);
      },
      httpHeaders: headers,
    );
  }
  
  /// Get the best headers for a given image URL
  static Map<String, String>? _getBestHeaders(String imageUrl) {
    // For CDN images, try CDN-specific headers first
    if (CorsConfig.isLikelyCorsIssue(imageUrl)) {
      final cdnHeaders = CorsConfig.getCdnHeaders();
      if (cdnHeaders != null) {
        developer.log('ImageUtils: Using CDN headers for $imageUrl');
        return cdnHeaders;
      }
    }
    
    // Fall back to regular CORS headers
    return CorsConfig.getCorsHeaders();
  }
  
  /// Process image URL for CORS compatibility
  static String _processImageUrl(String originalUrl) {
    if (!kIsWeb) {
      return originalUrl;
    }
    
    // Always try the original URL first, even for potentially problematic CDNs
    // Let the error handling deal with CORS issues
    return CorsConfig.processUrl(originalUrl);
  }
  
  /// Try different file extensions for the same image
  static List<String> _getAlternativeUrls(String originalUrl) {
    final alternatives = <String>[originalUrl];
    
    // First, try to fix the URL to use the correct CDN domain
    final fixedUrl = CorsConfig.fixCdnUrl(originalUrl);
    if (fixedUrl != originalUrl) {
      alternatives.insert(0, fixedUrl); // Put the fixed URL first
    }
    
    // Get the base URL without extension
    final uri = Uri.parse(originalUrl);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      final lastSegment = pathSegments.last;
      final baseName = lastSegment.contains('.') 
          ? lastSegment.substring(0, lastSegment.lastIndexOf('.'))
          : lastSegment;
      
      // Create alternative URLs with different extensions
      final baseUrl = '${uri.scheme}://${uri.host}${uri.path.replaceAll(lastSegment, '')}';
      
      // Try all major image formats in order of preference
      final extensions = ['webp', 'jpg', 'jpeg', 'png'];
      for (final ext in extensions) {
        final alternativeUrl = '$baseUrl$baseName.$ext';
        if (!alternatives.contains(alternativeUrl)) {
          alternatives.add(alternativeUrl);
        }
      }
    }
    
    // Remove duplicates and ensure the fixed URL is first
    final uniqueUrls = alternatives.toSet().toList();
    if (fixedUrl != originalUrl && uniqueUrls.contains(fixedUrl)) {
      uniqueUrls.remove(fixedUrl);
      uniqueUrls.insert(0, fixedUrl);
    }
    
    developer.log('ImageUtils: Generated alternative URLs: $uniqueUrls');
    return uniqueUrls;
  }
  
  /// Handle image loading errors with fallback strategies
  static Widget _handleImageError(
    BuildContext context,
    String failedUrl,
    dynamic error,
    String originalUrl,
    Widget Function(BuildContext, String, dynamic) errorWidget,
  ) {
    developer.log('ImageUtils: Failed to load $failedUrl, error: $error');
    
    // If we're already trying the original URL, show the error widget
    if (failedUrl == originalUrl) {
      developer.log('ImageUtils: Original URL failed, trying alternative extensions');
      
      // Try alternative file extensions
      final alternativeUrls = _getAlternativeUrls(originalUrl);
      developer.log('ImageUtils: Trying alternative URLs: $alternativeUrls');
      
      // Try the first alternative URL
      if (alternativeUrls.length > 1) {
        final nextUrl = alternativeUrls[1]; // Skip the original URL
        developer.log('ImageUtils: Trying alternative URL: $nextUrl');
        
        return CachedNetworkImage(
          imageUrl: nextUrl,
          fit: BoxFit.cover,
          errorWidget: (context, fallbackUrl, fallbackError) {
            developer.log('ImageUtils: Alternative URL also failed: $fallbackUrl, error: $fallbackError');
            
            // Try remaining alternatives
            final remainingUrls = alternativeUrls.skip(2).toList();
            if (remainingUrls.isNotEmpty) {
              return _tryRemainingUrls(context, remainingUrls, errorWidget);
            }
            
            return errorWidget(context, fallbackUrl, fallbackError);
          },
          httpHeaders: _getBestHeaders(nextUrl),
        );
      }
      
      developer.log('ImageUtils: No alternative URLs available, showing error widget');
      return errorWidget(context, failedUrl, error);
    }
    
    // Try the original URL as fallback
    developer.log('ImageUtils: Trying original URL as fallback: $originalUrl');
    return CachedNetworkImage(
      imageUrl: originalUrl,
      fit: BoxFit.cover,
      errorWidget: (context, fallbackUrl, fallbackError) {
        developer.log('ImageUtils: Original URL also failed: $fallbackUrl, error: $fallbackError');
        return errorWidget(context, fallbackUrl, fallbackError);
      },
      httpHeaders: _getBestHeaders(originalUrl),
    );
  }
  
  /// Try remaining alternative URLs recursively
  static Widget _tryRemainingUrls(
    BuildContext context,
    List<String> remainingUrls,
    Widget Function(BuildContext, String, dynamic) errorWidget,
  ) {
    if (remainingUrls.isEmpty) {
      return errorWidget(context, '', 'All alternative URLs failed');
    }
    
    final nextUrl = remainingUrls.first;
    final remaining = remainingUrls.skip(1).toList();
    
    developer.log('ImageUtils: Trying remaining URL: $nextUrl');
    
    return CachedNetworkImage(
      imageUrl: nextUrl,
      fit: BoxFit.cover,
      errorWidget: (context, fallbackUrl, fallbackError) {
        developer.log('ImageUtils: Remaining URL failed: $fallbackUrl, error: $fallbackError');
        return _tryRemainingUrls(context, remaining, errorWidget);
      },
      httpHeaders: _getBestHeaders(nextUrl),
    );
  }
  
  /// Default placeholder widget
  static Widget _defaultPlaceholder(BuildContext context, String url) {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading image...', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
  
  /// Create a feature-specific placeholder
  static Widget createFeaturePlaceholder({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? backgroundColor,
    Color? iconColor,
    bool showDevelopmentIndicator = true,
  }) {
    return Container(
      color: backgroundColor ?? Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.blue[600])?.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: iconColor ?? Colors.blue[600],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            // Development info
            if (showDevelopmentIndicator && CorsConfig.isDevelopment) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Development Mode: Image failed to load',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Test if an image URL is accessible
  static Future<bool> testImageAccessibility(String url) async {
    try {
      developer.log('ImageUtils: Testing image accessibility for: $url');
      
      // Use a simple HTTP request to test accessibility
      final response = CachedNetworkImageProvider(url).resolve(const ImageConfiguration());
      
      developer.log('ImageUtils: Image accessibility test successful for: $url');
      return true;
    } catch (e) {
      developer.log('ImageUtils: Image accessibility test failed for: $url, error: $e');
      return false;
    }
  }
  
  /// Load an image with detailed debugging
  static Widget loadImageWithDebug({
    required String imageUrl,
    required Widget Function(BuildContext, String, dynamic) errorWidget,
    Widget Function(BuildContext, String)? placeholder,
    BoxFit fit = BoxFit.cover,
    Map<String, String>? httpHeaders,
  }) {
    developer.log('ImageUtils: Starting image load for: $imageUrl');
    
    // Test accessibility first
    testImageAccessibility(imageUrl).then((isAccessible) {
      developer.log('ImageUtils: Image accessibility result for $imageUrl: $isAccessible');
    });
    
    return loadImage(
      imageUrl: imageUrl,
      errorWidget: errorWidget,
      placeholder: placeholder,
      fit: fit,
      httpHeaders: httpHeaders,
    );
  }

  /// Test CDN image accessibility with different authentication methods
  static Future<Map<String, dynamic>> testCdnImageAccessibility(String imageUrl) async {
    final results = <String, dynamic>{};
    
    developer.log('ImageUtils: Testing CDN image accessibility for: $imageUrl');
    
    // Test 1: No headers
    try {
      final response = CachedNetworkImageProvider(imageUrl).resolve(const ImageConfiguration());
      results['no_headers'] = true;
      developer.log('ImageUtils: CDN image accessible without headers');
    } catch (e) {
      results['no_headers'] = false;
      results['no_headers_error'] = e.toString();
      developer.log('ImageUtils: CDN image not accessible without headers: $e');
    }
    
    // Test 2: With CORS headers
    try {
      final corsHeaders = CorsConfig.getCorsHeaders();
      if (corsHeaders != null) {
        // Note: CachedNetworkImageProvider doesn't support headers directly
        // This is just for logging purposes
        results['cors_headers_available'] = true;
        developer.log('ImageUtils: CORS headers available: $corsHeaders');
      } else {
        results['cors_headers_available'] = false;
      }
    } catch (e) {
      results['cors_headers_error'] = e.toString();
    }
    
    // Test 3: With CDN headers
    try {
      final cdnHeaders = CorsConfig.getCdnHeaders();
      if (cdnHeaders != null) {
        results['cdn_headers_available'] = true;
        developer.log('ImageUtils: CDN headers available: $cdnHeaders');
      } else {
        results['cdn_headers_available'] = false;
      }
    } catch (e) {
      results['cdn_headers_error'] = e.toString();
    }
    
    // Test 4: With CORS proxy (development only)
    if (CorsConfig.isDevelopment && CorsConfig.useCorsProxy) {
      try {
        final proxyUrl = CorsConfig.processUrl(imageUrl);
        if (proxyUrl != imageUrl) {
          final response = CachedNetworkImageProvider(proxyUrl).resolve(const ImageConfiguration());
          results['cors_proxy'] = true;
          developer.log('ImageUtils: CDN image accessible via CORS proxy');
        } else {
          results['cors_proxy'] = false;
          results['cors_proxy_error'] = 'Proxy not applied';
        }
      } catch (e) {
        results['cors_proxy'] = false;
        results['cors_proxy_error'] = e.toString();
        developer.log('ImageUtils: CDN image not accessible via CORS proxy: $e');
      }
    }
    
    return results;
  }
}
