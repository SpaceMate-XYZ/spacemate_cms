import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';

void main() {
  group('MenuCategory', () {
    test('should have correct values', () {
      // Assert
      expect(MenuCategory.home.toString(), 'home');
      expect(MenuCategory.transport.toString(), 'transport');
      expect(MenuCategory.access.toString(), 'access');
      expect(MenuCategory.facilities.toString(), 'facilities');
      expect(MenuCategory.discover.toString(), 'discover');
    });

    test('should parse from string', () {
      // Assert
      expect(MenuCategoryX.fromString('home'), MenuCategory.home);
      expect(MenuCategoryX.fromString('transport'), MenuCategory.transport);
      expect(MenuCategoryX.fromString('access'), MenuCategory.access);
      expect(MenuCategoryX.fromString('facilities'), MenuCategory.facilities);
      expect(MenuCategoryX.fromString('discover'), MenuCategory.discover);
    });

    test('should throw error for invalid string', () {
      // Act & Assert
      expect(
        () => MenuCategoryX.fromString('invalid'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should return correct display name', () {
      // Assert
      expect(MenuCategory.home.displayName, 'Home');
      expect(MenuCategory.transport.displayName, 'Transport');
      expect(MenuCategory.access.displayName, 'Access');
      expect(MenuCategory.facilities.displayName, 'Facilities');
      expect(MenuCategory.discover.displayName, 'Discover');
    });

    test('should return correct icon', () {
      // Assert
      expect(MenuCategory.home.icon, 'home');
      expect(MenuCategory.transport.icon, 'directions_car');
      expect(MenuCategory.access.icon, 'fingerprint');
      expect(MenuCategory.facilities.icon, 'apartment');
      expect(MenuCategory.discover.icon, 'explore');
    });
  });
}
