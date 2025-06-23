enum MenuCategory {
  home,
  transport,
  access,
  facilities,
  discover;
  
  @override
  String toString() => name;
}

extension MenuCategoryX on MenuCategory {
  String get displayName {
    switch (this) {
      case MenuCategory.home:
        return 'Home';
      case MenuCategory.transport:
        return 'Transport';
      case MenuCategory.access:
        return 'Access';
      case MenuCategory.facilities:
        return 'Facilities';
      case MenuCategory.discover:
        return 'Discover';
    }
  }

  String get icon {
    switch (this) {
      case MenuCategory.home:
        return 'home';
      case MenuCategory.transport:
        return 'directions_car';
      case MenuCategory.access:
        return 'fingerprint';
      case MenuCategory.facilities:
        return 'apartment';
      case MenuCategory.discover:
        return 'explore';
    }
  }

  static MenuCategory fromString(String value) {
    switch (value) {
      case 'home':
        return MenuCategory.home;
      case 'transport':
        return MenuCategory.transport;
      case 'access':
        return MenuCategory.access;
      case 'facilities':
        return MenuCategory.facilities;
      case 'facility': // backward compatibility
        return MenuCategory.facilities;
      case 'discover':
        return MenuCategory.discover;
      default:
        throw ArgumentError('Invalid MenuCategory value: $value');
    }
  }
}
