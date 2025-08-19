import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/core/config/cors_config.dart';

void main() {
  test('fixCdnUrl replaces r2.dev domain and jpg -> webp', () {
    const original = 'https://pub-a82fb85882784f3591b34db19d350dfc.r2.dev/path/image.jpg';
    final fixed = CorsConfig.fixCdnUrl(original);
    expect(fixed.contains('onboardingimages.spacemate.xyz'), isTrue);
    expect(fixed.endsWith('.webp'), isTrue);
  });

  test('fixCdnUrl leaves other urls unchanged', () {
    const original = 'https://cdn.example.com/image.png';
    final fixed = CorsConfig.fixCdnUrl(original);
    expect(fixed, equals(original));
  });
}
