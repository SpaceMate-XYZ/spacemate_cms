import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

void main() {
  const tMenuItemModel = MenuItemModel(
    id: '1',
    title: 'Parking',
    icon: 'local_parking',
    category: MenuCategory.transport,
    route: '/transport/parking',
    isActive: true,
    order: 1,
    badgeCount: 3,
    requiredPermissions: ['user'],
    analyticsId: 'transport_parking',
  );

  final tJson = {
    'id': '1',
    'title': 'Parking',
    'icon': 'local_parking',
    'category': 'transport',
    'route': '/transport/parking',
    'isActive': true,
    'order': 1,
    'badgeCount': 3,
    'requiredPermissions': ['user'],
    'analyticsId': 'transport_parking',
  };

  group('MenuItemModel', () {
    test('should be a subclass of MenuItemEntity', () {
      expect(tMenuItemModel, isA<MenuItemEntity>());
    });

    test('should return a valid model from JSON', () {
      // Act
      final result = MenuItemModel.fromJson(tJson);
      
      // Assert
      expect(result, equals(tMenuItemModel));
    });

    test('should return a JSON map containing proper data', () {
      // Act
      final result = tMenuItemModel.toJson();
      
      // Assert
      final expectedMap = {
        'id': '1',
        'title': 'Parking',
        'icon': 'local_parking',
        'category': 'transport',
        'route': '/transport/parking',
        'is_active': 1,
        'isActive': true,
        'order': 1,
        'badge_count': 3,
        'badgeCount': 3,
        'required_permissions': ['user'],
        'requiredPermissions': ['user'],
        'analytics_id': 'transport_parking',
        'analyticsId': 'transport_parking',
      };
      expect(result, equals(expectedMap));
    });

    test('should return default values for optional fields', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Parking',
        'icon': 'local_parking',
        'category': 'transport',
        'route': '/transport/parking',
        'analyticsId': 'transport_parking',
      };
      
      // Act
      final result = MenuItemModel.fromJson(json);
      
      // Assert
      expect(result.isActive, isTrue);
      expect(result.order, isNull);
      expect(result.badgeCount, isZero);
      expect(result.requiredPermissions, isEmpty);
    });

    test('should handle all MenuCategory values', () {
      // Arrange
      final categories = MenuCategory.values;
      
      for (final category in categories) {
        final json = {
          'id': '1',
          'title': 'Test Item',
          'icon': 'icon',
          'category': category.toString().split('.').last,
          'route': '/test',
          'analyticsId': 'test_id',
        };
        
        // Act & Assert
        expect(
          () => MenuItemModel.fromJson(json),
          returnsNormally,
          reason: 'Should handle ${category.toString()}',
        );
      }
    });

    test('should handle null/empty values for optional fields', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Item',
        'icon': 'icon',
        'category': 'transport',
        'route': '/test',
        'analyticsId': 'test_id',
        'order': null,
        'badgeCount': null,
        'requiredPermissions': null,
        'imageUrl': null,
      };
      
      // Act
      final result = MenuItemModel.fromJson(json);
      
      // Assert
      expect(result.order, isNull);
      expect(result.badgeCount, isZero);
      expect(result.requiredPermissions, isEmpty);
      expect(result.imageUrl, isNull);
    });

    test('should handle special characters in strings', () {
      // Arrange
      const specialString = '!@#%^&*()_+{}|:<>?~[];\',./';
      final json = {
        'id': '1',
        'title': specialString,
        'icon': specialString,
        'category': 'transport',
        'route': specialString,
        'analyticsId': specialString,
      };
      
      // Act
      final result = MenuItemModel.fromJson(json);
      
      // Assert
      expect(result.title, equals(specialString));
      expect(result.icon, equals(specialString));
      expect(result.route, equals(specialString));
      expect(result.analyticsId, equals(specialString));
    });

    test('should throw ArgumentError for invalid JSON', () {
      // Arrange
      final invalidJson = {'invalid': 'data'};
      
      // Act & Assert
      expect(
        () => MenuItemModel.fromJson(invalidJson),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should handle missing or invalid fields', () {
      // Test with minimal valid JSON (only required fields)
      final minimalJson = {
        'id': '1',
        'title': 'Test',
        'icon': 'icon',
        'category': 'transport',
        'route': '/test',
        'analyticsId': 'test_id',
      };
      
      // Should not throw with minimal valid JSON
      expect(
        () => MenuItemModel.fromJson(minimalJson),
        returnsNormally,
      );
      
      // Test with missing category (should throw)
      final jsonWithoutCategory = Map<String, dynamic>.from(minimalJson)..remove('category');
      expect(
        () => MenuItemModel.fromJson(jsonWithoutCategory),
        throwsA(isA<ArgumentError>()),
        reason: 'Should throw when category is missing',
      );
      
      // Test with invalid category (should throw)
      final jsonWithInvalidCategory = Map<String, dynamic>.from(minimalJson)..['category'] = 'invalid_category';
      expect(
        () => MenuItemModel.fromJson(jsonWithInvalidCategory),
        throwsA(isA<ArgumentError>()),
        reason: 'Should throw when category is invalid',
      );
      
      // Test with other missing fields (should not throw)
      final otherRequiredFields = ['id', 'title', 'icon', 'route', 'analyticsId'];
      for (final field in otherRequiredFields) {
        final json = Map<String, dynamic>.from(minimalJson)..remove(field);
        expect(
          () => MenuItemModel.fromJson(json),
          returnsNormally,
          reason: 'Should not throw when $field is missing',
        );
      }
    });
  });
}
