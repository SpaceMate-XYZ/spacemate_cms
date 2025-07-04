import 'package:sqflite/sqflite.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/core/database/database_helper.dart';

class OnboardingCarouselDao {
  static const String table = 'onboarding_carousel';
  final Database? testDb;

  OnboardingCarouselDao({this.testDb});

  Future<Database> _getDb() async {
    if (testDb != null) return testDb!;
    return await DatabaseHelper.instance.database;
  }

  Future<void> cacheOnboardingSlides(List<OnboardingSlide> slides, String featureName) async {
    final db = await _getDb();
    final batch = db.batch();
    // Remove old slides for this feature
    batch.delete(table, where: 'feature_name = ?', whereArgs: [featureName]);
    // Insert new slides
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final slide in slides) {
      batch.insert(table, {
        'id': slide.id,
        'feature_name': featureName,
        'screen': slide.screen,
        'title': slide.title,
        'image_url': slide.imageUrl,
        'header': slide.header,
        'body': slide.body,
        'button_label': slide.buttonLabel,
        'cached_at': now,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<OnboardingSlide>> getOnboardingSlides(String featureName) async {
    final db = await _getDb();
    final result = await db.query(
      table,
      where: 'feature_name = ?',
      whereArgs: [featureName],
      orderBy: 'screen ASC',
    );
    return result.map((row) => OnboardingSlide(
      id: row['id'] as int,
      feature: row['feature_name'] as String,
      screen: row['screen']?.toString() ?? '',
      title: row['title']?.toString() ?? '',
      imageUrl: row['image_url']?.toString() ?? '',
      header: row['header']?.toString() ?? '',
      body: row['body']?.toString() ?? '',
      buttonLabel: row['button_label']?.toString(),
    )).toList();
  }

  Future<void> clearOnboardingSlides(String featureName) async {
    final db = await _getDb();
    await db.delete(table, where: 'feature_name = ?', whereArgs: [featureName]);
  }
} 