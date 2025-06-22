import 'package:flutter_dotenv/flutter_dotenv.dart';

class StrapiConfig {
  // Load environment variables
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  // Strapi server URL from environment variables
  static String get baseUrl => dotenv.get('STRAPI_BASE_URL');
  
  // API prefix (usually '/api' for Strapi v4+)
  static const String apiPrefix = '/api';
  
  // Timeout duration for API calls
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Endpoints
  static const String menuScreensEndpoint = '/menu-screens';
  
  // Helper method to get the full API URL
  static String getApiUrl(String endpoint) {
    return '$baseUrl$apiPrefix$endpoint';
  }
}
