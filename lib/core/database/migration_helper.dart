import 'package:sqflite/sqflite.dart';

class MigrationHelper {
  static const _databaseVersion = 1;
  
  static Future<void> migrate(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
      // Initial database creation is handled by DatabaseHelper
      return;
    }
    
    // Example of a future migration:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE menu_items ADD COLUMN new_column TEXT');
    // }
    
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
