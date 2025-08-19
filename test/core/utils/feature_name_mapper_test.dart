import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/core/utils/feature_name_mapper.dart';

void main() {
  test('getFeatureNameFromLabel returns expected feature name', () {
    expect(FeatureNameMapper.getFeatureNameFromLabel('Parking'), 'parking');
    expect(FeatureNameMapper.getFeatureNameFromLabel('EV Charging'), 'evcharging');
    expect(FeatureNameMapper.getFeatureNameFromLabel('Nonexistent'), isNull);
  });

  test('getLabelFromFeatureName returns expected label', () {
    expect(FeatureNameMapper.getLabelFromFeatureName('parking'), 'Parking');
    expect(FeatureNameMapper.getLabelFromFeatureName('evcharging'), 'EV Charging');
    expect(FeatureNameMapper.getLabelFromFeatureName('unknown'), isNull);
  });

  test('getAllFeatureNames and getAllMenuLabels contain expected values', () {
    final names = FeatureNameMapper.getAllFeatureNames();
    final labels = FeatureNameMapper.getAllMenuLabels();

    expect(names, contains('parking'));
    expect(labels, contains('Parking'));
    expect(names.length, equals(labels.length));
  });
}
