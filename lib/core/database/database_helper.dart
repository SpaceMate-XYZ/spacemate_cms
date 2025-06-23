import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'migration_helper.dart';

class DatabaseHelper {
  static const _databaseName = 'spacemate_cms.db';
  static const _databaseVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  bool _isInitialized = false;

  DatabaseHelper._init();

  static bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Database is not supported on the web.');
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (_isDesktop) {
      sqfliteFfiInit();
    }

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    final factory = _isDesktop ? databaseFactoryFfi : databaseFactory;

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    return await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: _createDb,
        onUpgrade: _upgradeDb,
        onDowngrade: _downgradeDb,
        onOpen: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await _createSchema(db);
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    await MigrationHelper.migrate(db, oldVersion, newVersion);
  }

  Future<void> _downgradeDb(Database db, int oldVersion, int newVersion) async {
    await MigrationHelper.onDowngrade(db, oldVersion, newVersion);
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS menu_items (
        id INTEGER PRIMARY KEY,
        slug TEXT NOT NULL,
        label TEXT NOT NULL,
        icon TEXT,
        "order" INTEGER NOT NULL,
        is_visible INTEGER NOT NULL,
        is_available INTEGER NOT NULL,
        badge_count INTEGER,
        cached_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_menu_items_slug ON menu_items(slug)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_menu_items_order ON menu_items("order")');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cache_metadata (
        slug TEXT PRIMARY KEY,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<void> clearDatabase() async {
    if (kIsWeb) return;
    final db = await database;
    final batch = db.batch();
    batch.delete('menu_items');
    await batch.commit();
  }

  Future<void> close() async {
    if (kIsWeb || _database == null) return;
    await _database!.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    if (kIsWeb) return;
    await close();
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    if (await File(path).exists()) {
      await databaseFactory.deleteDatabase(path);
    }
  }

  Future<void> initialize() async {
    if (kIsWeb || _isInitialized) return;
    // If database initialization fails on a supported platform (mobile/desktop),
    // it will now throw an exception, preventing the app from starting in a broken state.
    // This is safer than catching the error and pretending initialization succeeded.
    await database;
    _isInitialized = true;
  }
}
