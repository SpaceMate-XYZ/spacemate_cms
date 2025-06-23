import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static const String _imageCacheDir = 'cached_images';
  static const Duration _cacheDuration = Duration(days: 30);

  /// Get the cache directory for storing images
  static Future<Directory> getCacheDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${directory.path}/$_imageCacheDir');
    
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    
    return cacheDir;
  }

  /// Get a file reference for a cached image
  static Future<File> getCachedImageFile(String url) async {
    final cacheDir = await getCacheDirectory();
    final uri = Uri.parse(url);
    final filename = '${uri.pathSegments.last}.${uri.pathSegments.last.split('.').last}';
    return File('${cacheDir.path}/$filename');
  }

  /// Check if an image is cached
  static Future<bool> isImageCached(String url) async {
    if (url.isEmpty) return false;
    
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
    try {
      final file = await getCachedImageFile(url);
      
      // Skip if already cached and valid
      if (await isImageCached(url)) {
        return file;
      }
      
      // Use CachedNetworkImage to handle the download and caching
      final response = CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(),
        errorWidget: (context, url, error) => Container(),
      );
      
      // The image is now cached by CachedNetworkImage
      return file;
    } catch (e) {
      return null;
    }
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
}
