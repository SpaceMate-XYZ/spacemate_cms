class FeatureNameMapper {
  static const Map<String, String> _labelToFeatureName = {
    'Parking': 'parking',
    'Valet Parking': 'valetparking',
    'EV Charging': 'evcharging',
    'Building': 'building',
    'Office': 'office',
    'Lockers': 'lockers',
    'Meetings': 'meetings',
    'Visitors': 'visitors',
    'Requests': 'requests',
    'Desks': 'desks',
    'Shuttles': 'shuttles',
    'Food Delivery': 'fooddelivery',
    'Cafeteria': 'cafeteria',
    'Vending': 'vending',
    'Fitness': 'fitness',
    'Sports': 'sports',
    'Games': 'games',
    'Doctor': 'doctor',
    'Counselor': 'counselor',
    'Spa': 'spa',
    'Lobby': 'lobby',
    'Lift': 'lift',
    'Printer': 'printer',
    'Carpools': 'carpools',
    'Company Cabs': 'companycabs',
  };

  /// Maps a menu label to its corresponding feature name
  static String? getFeatureNameFromLabel(String label) {
    return _labelToFeatureName[label];
  }

  /// Maps a feature name to its corresponding menu label
  static String? getLabelFromFeatureName(String featureName) {
    for (final entry in _labelToFeatureName.entries) {
      if (entry.value == featureName) {
        return entry.key;
      }
    }
    return null;
  }

  /// Returns all available feature names
  static List<String> getAllFeatureNames() {
    return _labelToFeatureName.values.toList();
  }

  /// Returns all available menu labels
  static List<String> getAllMenuLabels() {
    return _labelToFeatureName.keys.toList();
  }
} 