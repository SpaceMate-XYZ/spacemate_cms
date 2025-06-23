import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

void main() {
  const tMenuItem = MenuItemEntity(
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

  group('MenuItemEntity', () {
    test('should support value equality', () {
      // Arrange
      const anotherMenuItem = MenuItemEntity(
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
      
      // Assert
      expect(tMenuItem, equals(anotherMenuItem));
    });

    test('should return correct props', () {
      // Assert
      expect(
        tMenuItem.props,
        equals([
          '1', // id
          'Parking', // title
          'local_parking', // icon
          MenuCategory.transport, // category
          '/transport/parking', // route
          true, // isActive
          1, // order
          3, // badgeCount
          ['user'], // requiredPermissions
          'transport_parking', // analyticsId
          null, // imageUrl
        ]),
      );
    });

    test('should return a copy with updated values', () {
      // Act
      final result = tMenuItem.copyWith(
        title: 'Valet Parking',
        badgeCount: 5,
      );
      
      // Assert
      expect(result.title, 'Valet Parking');
      expect(result.badgeCount, 5);
      expect(result.icon, tMenuItem.icon);
      expect(result.category, tMenuItem.category);
    });
  });
}
