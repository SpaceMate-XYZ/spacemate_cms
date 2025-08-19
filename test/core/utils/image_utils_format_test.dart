import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/core/utils/image_utils.dart';

void main() {
  test('formatBytes formats bytes correctly', () {
    expect(ImageUtils.formatBytes(0), equals('0 B'));
    expect(ImageUtils.formatBytes(1024), contains('KB'));
    expect(ImageUtils.formatBytes(1024 * 1024), contains('MB'));
    expect(ImageUtils.formatBytes(123456789, decimals: 1), isA<String>());
  });
}
