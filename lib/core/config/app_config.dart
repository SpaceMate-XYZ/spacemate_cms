import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spacemate/core/config/cors_proxy.dart';

/// Application configuration class that handles environment variables
/// and provides fallback values for development
class AppConfig {
  // Default Strapi URLs
  static const String _defaultMainStrapiUrl = 'https://strapi.dev.spacemate.xyz';
  static const String _defaultApiPrefix = '/api';
  static const String _defaultCarouselStrapiUrl = 'https://strapi.dev.spacemate.xyz';
  
  /// Initialize the configuration
  static Future<void> init() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // If .env file doesn't exist, continue with defaults
      debugPrint('No .env file found, using default configuration');
    }
  }
  
  /// Get main Strapi base URL (for menu data) from environment or use default
  static String get mainStrapiBaseUrl {
    return dotenv.env['MAIN_STRAPI_BASE_URL'] ?? _defaultMainStrapiUrl;
  }
  
  /// Get carousel Strapi base URL (for onboarding data) from environment or use default
  static String get carouselStrapiBaseUrl {
    return dotenv.env['CAROUSEL_STRAPI_BASE_URL'] ?? _defaultCarouselStrapiUrl;
  }
  
  /// Get API prefix from environment or use default
  static String get apiPrefix {
    return dotenv.env['STRAPI_API_PREFIX'] ?? _defaultApiPrefix;
  }
  
  /// Get API token from environment (optional)
  static String? get apiToken {
    final token = dotenv.env['STRAPI_API_TOKEN'];
    return token?.isNotEmpty == true ? token : null;
  }
  
  /// Get app name from environment or use default
  static String get appName {
    return dotenv.env['APP_NAME'] ?? 'Spacemate CMS';
  }
  
  /// Get app version from environment or use default
  static String get appVersion {
    return dotenv.env['APP_VERSION'] ?? '1.0.0';
  }
  
  /// Check if debug mode is enabled
  static bool get isDebug {
    final value = dotenv.env['DEBUG'];
    return value?.toLowerCase() == 'true' || kDebugMode;
  }
  
  /// Get log level from environment or use default
  static String get logLevel {
    return dotenv.env['LOG_LEVEL'] ?? 'info';
  }
  
  /// Get X2U CORS proxy email from environment
  static String? get x2uEmail => dotenv.env['X2U_EMAIL'];

  /// Get X2U CORS proxy API key from environment
  static String? get x2uApiKey => dotenv.env['X2U_API_KEY'];

  /// Helper to build a X2U CORS proxy URL for a given Strapi endpoint
  static String buildX2UProxyUrl(String fullStrapiUrl) {
    final email = x2uEmail;
    final apiKey = x2uApiKey;
    if (email != null && apiKey != null) {
      final encodedUrl = Uri.encodeComponent(fullStrapiUrl);
      return 'https://go.x2u.in/proxy?email=$email&apiKey=$apiKey&url=$encodedUrl';
    }
    return fullStrapiUrl;
  }

  /// Get full API URL for main Strapi by combining base URL and prefix
  static String getMainApiUrl(String endpoint) {
    final url = '$mainStrapiBaseUrl$apiPrefix$endpoint';
    return CorsProxy.wrap(url);
  }
  
  /// Get full API URL for carousel Strapi by combining base URL and prefix
  static String getCarouselApiUrl(String endpoint) {
    final url = '$carouselStrapiBaseUrl$apiPrefix$endpoint';
    return CorsProxy.wrap(url);
  }
  
  /// Check if authentication is required
  static bool get requiresAuth {
    return apiToken != null;
  }
} 