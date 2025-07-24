import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_carousel_dao.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';

void main() {
  late Database db;
  late OnboardingCarouselDao dao;

  setUpAll(() async {
    // Initialize database factory for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE onboarding_carousel (
            id INTEGER PRIMARY KEY,
            feature_name TEXT NOT NULL,
            screen TEXT,
            title TEXT,
            image_url TEXT,
            header TEXT,
            body TEXT,
            button_label TEXT,
            cached_at INTEGER NOT NULL
          )
        ''');
      },
    );
    dao = OnboardingCarouselDao(testDb: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('caches and retrieves onboarding slides', () async {
    final slides = [
      const OnboardingSlide(
        id: 1,
        feature: 'Parking',
        screen: '1',
        title: 'Welcome to Parking',
        imageUrl: 'https://example.com/image1.png',
        header: 'Find your perfect spot',
        body: 'Easily locate and reserve parking spaces.',
        buttonLabel: null,
      ),
      const OnboardingSlide(
        id: 2,
        feature: 'Parking',
        screen: '2',
        title: 'Secure and Convenient',
        imageUrl: 'https://example.com/image2.png',
        header: 'Your vehicle is safe with us',
        body: 'Advanced security features for peace of mind.',
        buttonLabel: 'Get Started',
      ),
    ];
    await dao.cacheOnboardingSlides(slides, 'Parking');
    final result = await dao.getOnboardingSlides('Parking');
    expect(result.length, 2);
    expect(result[0].title, 'Welcome to Parking');
    expect(result[1].buttonLabel, 'Get Started');
  });

  test('clears onboarding slides for a feature', () async {
    final slides = [
      const OnboardingSlide(
        id: 1,
        feature: 'Parking',
        screen: '1',
        title: 'Welcome to Parking',
        imageUrl: 'https://example.com/image1.png',
        header: 'Find your perfect spot',
        body: 'Easily locate and reserve parking spaces.',
        buttonLabel: null,
      ),
    ];
    await dao.cacheOnboardingSlides(slides, 'Parking');
    await dao.clearOnboardingSlides('Parking');
    final result = await dao.getOnboardingSlides('Parking');
    expect(result, isEmpty);
  });
} 