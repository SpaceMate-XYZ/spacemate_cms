import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Utility to wrap URLs with the X2U CORS proxy for development
class CorsProxy {
  static String? get email => dotenv.env['X2U_EMAIL'];
  static String? get apiKey => dotenv.env['X2U_API_KEY'];

  /// Returns the proxied URL if X2U config is present, otherwise returns the original URL
  static String wrap(String url) {
    if (email != null && apiKey != null) {
      final encodedUrl = Uri.encodeComponent(url);
      return 'https://go.x2u.in/proxy?email=$email&apiKey=$apiKey&url=$encodedUrl';
    }
    return url;
  }
} 