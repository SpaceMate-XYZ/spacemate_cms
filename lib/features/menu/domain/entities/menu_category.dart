enum MenuCategory {
  home,
  transport,
  access,
  facility,
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
      case MenuCategory.facility:
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
      case MenuCategory.facility:
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
      case 'facility':
        return MenuCategory.facility;
      case 'discover':
        return MenuCategory.discover;
      default:
        throw ArgumentError('Invalid MenuCategory value: $value');
    }
  }
}
