import 'dart:developer' as developer;

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
    developer.log('FeatureNameMapper: Mapping label: "$label"');
    developer.log('FeatureNameMapper: Available labels: ${_labelToFeatureName.keys.toList()}');
    final result = _labelToFeatureName[label];
    developer.log('FeatureNameMapper: Mapped to: $result');
    
    if (result == null) {
      developer.log('FeatureNameMapper: WARNING - No mapping found for label: "$label"');
      developer.log('FeatureNameMapper: This might cause navigation to default to "requests"');
    }
    
    return result;
  }

  /// Maps a feature name to its corresponding menu label
  static String? getLabelFromFeatureName(String featureName) {
    developer.log('FeatureNameMapper: Reverse mapping feature name: "$featureName"');
    for (final entry in _labelToFeatureName.entries) {
      if (entry.value == featureName) {
        developer.log('FeatureNameMapper: Reverse mapped to: ${entry.key}');
        return entry.key;
      }
    }
    developer.log('FeatureNameMapper: WARNING - No reverse mapping found for feature name: "$featureName"');
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