import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

void main() {
  const tMenuItem = MenuItemEntity(
    id: 1,
    label: 'Parking',
    icon: 'local_parking',
    order: 1,
    isVisible: true,
    isAvailable: true,
    badgeCount: 3,
  );

  group('MenuItemEntity', () {
    test('should support value equality', () {
      // Arrange
      const anotherMenuItem = MenuItemEntity(
        id: 1,
        label: 'Parking',
        icon: 'local_parking',
        order: 1,
        isVisible: true,
        isAvailable: true,
        badgeCount: 3,
      );
      
      // Assert
      expect(tMenuItem, equals(anotherMenuItem));
    });

    test('should return correct props', () {
      // Assert
      expect(
        tMenuItem.props,
        equals([
          1, // id
          'Parking', // label
          'local_parking', // icon
          1, // order
          true, // isVisible
          true, // isAvailable
          3, // badgeCount
        ]),
      );
    });

    // Removed copyWith test as it's not available in MenuItemEntity
  });
}
