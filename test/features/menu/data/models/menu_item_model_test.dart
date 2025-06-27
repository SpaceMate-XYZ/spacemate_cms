import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

void main() {
  const tMenuItemModel = MenuItemModel(
    id: 1,
    label: 'Test Label',
    icon: 'test_icon',
    order: 1,
    isVisible: true,
    isAvailable: true,
    badgeCount: 5,
  );

  test(
    'should be a subclass of MenuItemEntity',
    () async {
      expect(tMenuItemModel, isA<MenuItemEntity>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is complete',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(
          '''
          {
            "id": 1,
            "attributes": {
              "label": "Test Label",
              "icon": "test_icon",
              "order": 1,
              "is_visible": true,
              "is_available": true,
              "badge_count": 5
            }
          }
          ''',
        );

        // Act
        final result = MenuItemModel.fromJson(jsonMap);

        // Assert
        expect(result, tMenuItemModel);
      },
    );

    test(
      'should return a valid model when the JSON has missing optional fields',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(
          '''
          {
            "id": 1,
            "attributes": {
              "label": "Test Label",
              "order": 1,
              "is_visible": true,
              "is_available": true
            }
          }
          ''',
        );
        const expectedModel = MenuItemModel(
          id: 1,
          label: 'Test Label',
          icon: null,
          order: 1,
          isVisible: true,
          isAvailable: true,
          badgeCount: null,
        );

        // Act
        final result = MenuItemModel.fromJson(jsonMap);

        // Assert
        expect(result, expectedModel);
      },
    );

    test(
      'should return a valid model when using "title" instead of "label"',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(
          '''
          {
            "id": 1,
            "attributes": {
              "title": "Test Label",
              "order": 1,
              "is_visible": true,
              "is_available": true
            }
          }
          ''',
        );
        const expectedModel = MenuItemModel(
          id: 1,
          label: 'Test Label',
          icon: null,
          order: 1,
          isVisible: true,
          isAvailable: true,
          badgeCount: null,
        );

        // Act
        final result = MenuItemModel.fromJson(jsonMap);

        // Assert
        expect(result, expectedModel);
      },
    );

    test(
      'should return a valid model when boolean and int values are strings',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(
          '''
          {
            "id": "1",
            "attributes": {
              "label": "Test Label",
              "order": "1",
              "is_visible": "true",
              "is_available": "0",
              "badge_count": "5"
            }
          }
          ''',
        );
        const expectedModel = MenuItemModel(
          id: 1,
          label: 'Test Label',
          icon: null,
          order: 1,
          isVisible: true,
          isAvailable: false,
          badgeCount: 5,
        );

        // Act
        final result = MenuItemModel.fromJson(jsonMap);

        // Assert
        expect(result, expectedModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // Act
        final result = tMenuItemModel.toJson();

        // Assert
        final expectedJsonMap = {
          'id': 1,
          'label': 'Test Label',
          'icon': 'test_icon',
          'order': 1,
          'is_visible': 1,
          'is_available': 1,
          'badge_count': 5,
        };
        expect(result, expectedJsonMap);
      },
    );

    test(
      'should return a JSON map with null optional fields handled',
      () async {
        // Arrange
        const modelWithNulls = MenuItemModel(
          id: 1,
          label: 'Test Label',
          icon: null,
          order: 1,
          isVisible: true,
          isAvailable: true,
          badgeCount: null,
        );

        // Act
        final result = modelWithNulls.toJson();

        // Assert
        final expectedJsonMap = {
          'id': 1,
          'label': 'Test Label',
          'icon': '', // icon is explicitly set to '' if null
          'order': 1,
          'is_visible': 1,
          'is_available': 1,
          'badge_count': null,
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}