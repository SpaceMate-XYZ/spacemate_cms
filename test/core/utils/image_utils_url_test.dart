import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spacemate/core/utils/image_utils.dart';
import 'package:spacemate/core/config/cors_config.dart';

void main() {
  test('getImageUrlWithCorsHandling delegates to CorsConfig.processUrl', () {
    const url = 'https://pub-a82fb85882784f3591b34db19d350dfc.r2.dev/path/image.jpg';
    final processed = ImageUtils.getImageUrlWithCorsHandling(url);
    final expected = CorsConfig.processUrl(url);
    expect(processed, equals(expected));
  });

  testWidgets('cachedImage builds a widget tree with placeholder', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ImageUtils.cachedImage(
          imageUrl: '',
          placeholderIcon: 'image',
          width: 48,
          height: 48,
        ),
      ),
    ));

    // Since imageUrl is empty, placeholder should be shown (Container with Icon)
    expect(find.byType(Icon), findsOneWidget);
  });
}
