import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/core/utils/strapi_url_builder.dart';

void main() {
  group('StrapiUrlBuilder', () {
    test('builds URL with resource only', () {
      expect(
        StrapiUrlBuilder.build(resource: 'screens'),
        '/api/screens',
      );
    });

    test('builds URL with populate', () {
      expect(
        StrapiUrlBuilder.build(resource: 'screens', populate: ['*']),
        '/api/screens?populate=%2A',
      );
    });

    test('builds URL with single filter', () {
      expect(
        StrapiUrlBuilder.build(
          resource: 'screens',
          filters: {'slug': {'\$eq': 'home'}},
        ),
        '/api/screens?filters%5Bslug%5D%5B%24eq%5D=home',
      );
    });

    test('builds URL with multiple filters and populate', () {
      expect(
        StrapiUrlBuilder.build(
          resource: 'spacemate-placeid-features',
          filters: {'feature_name': {'\$eq': 'parking'}, 'active': {'\$eq': true}},
          populate: ['*'],
        ),
        '/api/spacemate-placeid-features?filters%5Bfeature_name%5D%5B%24eq%5D=parking&filters%5Bactive%5D%5B%24eq%5D=true&populate=%2A',
      );
    });

    test('builds URL with extra params', () {
      expect(
        StrapiUrlBuilder.build(
          resource: 'screens',
          extraParams: {'sort': 'createdAt:desc'},
        ),
        '/api/screens?sort=createdAt%3Adesc',
      );
    });

    test('builds URL with all options', () {
      expect(
        StrapiUrlBuilder.build(
          resource: 'screens',
          filters: {'slug': {'\$eq': 'home'}},
          populate: ['*'],
          extraParams: {'sort': 'createdAt:desc'},
        ),
        '/api/screens?filters%5Bslug%5D%5B%24eq%5D=home&populate=%2A&sort=createdAt%3Adesc',
      );
    });

    test('handles filter value that is a closure by converting to string', () {
      expect(
        StrapiUrlBuilder.build(
          resource: 'screens',
          filters: {'slug': (a, b) => a == b},
        ),
        '/api/screens?filters%5Bslug%5D=Closure%3A+%28dynamic%2C+dynamic%29+%3D%3E+bool',
      );
    });

    test('builds URL with numeric filter value', () {
      expect(
        StrapiUrlBuilder.build(
          resource: 'screens',
          filters: {'id': {'\$eq': 42}},
        ),
        '/api/screens?filters%5Bid%5D%5B%24eq%5D=42',
      );
    });

    test('builds URL with boolean filter value', () {
      expect(
        StrapiUrlBuilder.build(
          resource: 'screens',
          filters: {'active': {'\$eq': true}},
        ),
        '/api/screens?filters%5Bactive%5D%5B%24eq%5D=true',
      );
    });

    test('builds URL with multiple populate values', () {
      expect(
        StrapiUrlBuilder.build(
          resource: 'screens',
          populate: ['MenuGrid', 'MenuItems'],
        ),
        '/api/screens?populate=MenuGrid%2CMenuItems',
      );
    });
  });
} 