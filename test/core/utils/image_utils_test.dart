import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/core/utils/image_utils.dart';
import 'package:spacemate/core/config/cors_config.dart';
import 'package:flutter/foundation.dart';

void main() {
  group('ImageUtils', () {
    test('should process image URL correctly for web', () {
      // Test with a problematic CDN URL
      const testUrl = 'https://pub-a82fb85882784f3591b34db19d350dfc.r2.dev/test.jpg';
      
      // Test the CORS detection
      expect(CorsConfig.isLikelyCorsIssue(testUrl), isTrue);
      
      // Test development URL generation
      final devUrl = CorsConfig.getDevelopmentImageUrl(testUrl);
      expect(devUrl, isNotEmpty);
      expect(devUrl, isNot(equals(testUrl)));
    }, skip: !kIsWeb);
    
    test('should create feature placeholder correctly', () {
      final placeholder = ImageUtils.createFeaturePlaceholder(
        icon: Icons.directions_car,
        title: 'Test Feature',
        subtitle: 'Test Description',
      );
      
      expect(placeholder, isA<Container>());
    });
    
    test('should handle non-CORS URLs correctly', () {
      const safeUrl = 'https://picsum.photos/400/300';
      expect(CorsConfig.isLikelyCorsIssue(safeUrl), isFalse);
    });
    
    test('should detect CDN URLs correctly', () {
      const cdnUrl = 'https://pub-a82fb85882784f3591b34db19d350dfc.r2.dev/lockers_onboarding_1.jpg';
      expect(CorsConfig.isLikelyCorsIssue(cdnUrl), isTrue);
      
      const nonCdnUrl = 'https://example.com/image.jpg';
      expect(CorsConfig.isLikelyCorsIssue(nonCdnUrl), isFalse);
    }, skip: !kIsWeb);
  });
} 