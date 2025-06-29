import 'package:flutter/foundation.dart';
import 'package:spacemate/core/config/app_config.dart';
import 'dart:developer' as developer;

/// Configuration for handling CORS issues in web builds
class CorsConfig {
  /// Whether to use a CORS proxy for image loading
  /// Set to true for development/testing when CDN doesn't support CORS
  static const bool useCorsProxy = true;
  
  /// Development proxy URL to bypass CORS issues
  static const String developmentProxyUrl = 'https://api.allorigins.win/raw?url=';
  
  /// Alternative CDN URLs that support CORS
  /// These can be used as fallbacks when the primary CDN fails
  static const List<String> corsEnabledCdnUrls = [
    // Add alternative CDN URLs here if available
    // 'https://your-cors-enabled-cdn.com/',
  ];
  
  /// Get the processed URL with CORS handling
  static String processUrl(String originalUrl) {
    if (!kIsWeb) {
      // No CORS issues on mobile/desktop
      return originalUrl;
    }
    
    // First, fix the CDN URL to use the correct domain and extension
    final fixedUrl = fixCdnUrl(originalUrl);
    if (fixedUrl != originalUrl) {
      developer.log('CorsConfig: Fixed CDN URL from $originalUrl to $fixedUrl');
    }
    
    // In development, use a CORS proxy to bypass CORS issues
    if (isDevelopment && useCorsProxy && isLikelyCorsIssue(fixedUrl)) {
      final proxyUrl = '$developmentProxyUrl${Uri.encodeComponent(fixedUrl)}';
      developer.log('CorsConfig: Using development proxy: $proxyUrl');
      return proxyUrl;
    }
    
    // For production or when proxy is disabled, return the fixed URL
    return fixedUrl;
  }
  
  /// Get HTTP headers for CORS requests
  static Map<String, String>? getCorsHeaders() {
    if (!kIsWeb) {
      return null;
    }
    
    // Try different header combinations for CDN authentication
    final headers = <String, String>{};
    
    // Add API token if available (might be needed for CDN access)
    final apiToken = AppConfig.apiToken;
    if (apiToken != null) {
      headers['Authorization'] = 'Bearer $apiToken';
    }
    
    // Add CDN-specific headers
    headers['User-Agent'] = 'Spacemate-App/1.0';
    headers['Accept'] = 'image/*';
    headers['Accept-Encoding'] = 'gzip, deflate, br';
    
    // Try without CORS headers first, as they might be causing issues
    return headers.isNotEmpty ? headers : null;
    
    // Alternative headers if needed:
    // return {
    //   'Origin': 'https://spacemate.xyz',
    //   'Access-Control-Request-Method': 'GET',
    //   'Access-Control-Request-Headers': 'Content-Type',
    // };
  }
  
  /// Get CDN-specific headers for authentication
  static Map<String, String>? getCdnHeaders() {
    final headers = <String, String>{};
    
    // Add API token if available
    final apiToken = AppConfig.apiToken;
    if (apiToken != null) {
      headers['Authorization'] = 'Bearer $apiToken';
    }
    
    // Add CDN-specific authentication headers
    // You might need to add specific headers for your CDN provider
    headers['X-CDN-Access'] = 'public'; // Example header
    
    return headers.isNotEmpty ? headers : null;
  }
  
  /// Check if a URL is likely to have CORS issues
  static bool isLikelyCorsIssue(String url) {
    if (!kIsWeb) {
      return false;
    }
    
    // Check if the URL is from a known problematic CDN
    if (url.contains('pub-a82fb85882784f3591b34db19d350dfc.r2.dev')) {
      return true;
    }
    
    // The onboardingimages.spacemate.xyz domain may have CORS issues in development
    if (url.contains('onboardingimages.spacemate.xyz') && isDevelopment) {
      return true;
    }
    
    return false;
  }
  
  /// Check if a URL is from the correct CDN domain
  static bool isCorrectCdnDomain(String url) {
    return url.contains('onboardingimages.spacemate.xyz');
  }
  
  /// Fix CDN URL to use the correct domain and extension
  static String fixCdnUrl(String originalUrl) {
    // If the URL is from the problematic CDN, convert it to the correct domain
    if (originalUrl.contains('pub-a82fb85882784f3591b34db19d350dfc.r2.dev')) {
      final fixedUrl = originalUrl.replaceAll(
        'pub-a82fb85882784f3591b34db19d350dfc.r2.dev',
        'onboardingimages.spacemate.xyz'
      );
      
      // Also fix the file extension to .webp if it's .jpg
      if (fixedUrl.toLowerCase().endsWith('.jpg')) {
        return fixedUrl.replaceAll(RegExp(r'\.jpg$', caseSensitive: false), '.webp');
      }
      
      return fixedUrl;
    }
    
    // If the URL is already from the correct domain but has wrong extension, fix it
    if (originalUrl.contains('onboardingimages.spacemate.xyz')) {
      if (originalUrl.toLowerCase().endsWith('.jpg')) {
        return originalUrl.replaceAll(RegExp(r'\.jpg$', caseSensitive: false), '.webp');
      }
    }
    
    return originalUrl;
  }
  
  /// Get a fallback image URL or placeholder
  static String getFallbackImageUrl(String originalUrl) {
    // Return a placeholder image or alternative URL
    return 'https://via.placeholder.com/400x300/cccccc/666666?text=Image+Not+Available';
  }
  
  /// Check if we're in development mode
  static bool get isDevelopment {
    return kDebugMode;
  }
  
  /// Get a development-friendly image URL (only used as last resort)
  static String getDevelopmentImageUrl(String originalUrl) {
    if (!isDevelopment) {
      return originalUrl;
    }
    
    // For development, you can use a local placeholder or a CORS-friendly service
    // Option 1: Use a CORS-friendly placeholder service
    return 'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch}';
    
    // Option 2: Use a local asset (you'd need to add placeholder images to assets)
    // return 'assets/images/placeholder.jpg';
  }
} 