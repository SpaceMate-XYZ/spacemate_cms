import 'package:sqflite/sqflite.dart';

class MigrationHelper {
  static const _databaseVersion = 2;
  
  static Future<void> migrate(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
      // Initial database creation is handled by DatabaseHelper
      return;
    }
    // Migration for onboarding_carousel table (version 2)
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS onboarding_carousel (
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
      await db.execute('CREATE INDEX IF NOT EXISTS idx_onboarding_carousel_feature_name ON onboarding_carousel(feature_name)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_onboarding_carousel_screen ON onboarding_carousel(screen)');
    }
    // Add more migrations as needed when the database version increases
    // Each migration should be in its own if block and increment the version number
  }
  
  static Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    // Handle database downgrade if needed
    // This is more complex and might require data backup/restore
    await db.execute('DROP TABLE IF EXISTS menu_items');
    await db.execute('''
      CREATE TABLE menu_items (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        icon TEXT NOT NULL,
        category TEXT NOT NULL,
        route TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        "order" INTEGER,
        badge_count INTEGER NOT NULL DEFAULT 0,
        required_permissions TEXT,
        analytics_id TEXT NOT NULL,
        image_url TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }
}
