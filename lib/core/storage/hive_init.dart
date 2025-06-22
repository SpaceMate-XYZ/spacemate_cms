import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spacemate/features/menu/data/adapters/menu_item_model_adapter.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

class HiveInit {
  static Future<void> init() async {
    try {
      // Initialize Hive with the app's documents directory
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);

      // Register adapters
      Hive.registerAdapter(MenuItemModelAdapter());
      
      // Open boxes
      await Hive.openBox('app_cache');
      
      print('Hive initialized successfully');
    } catch (e) {
      print('Failed to initialize Hive: $e');
      rethrow;
    }
  }

  static Future<void> clearAllBoxes() async {
    try {
      await Hive.box('app_cache').clear();
      print('All Hive boxes cleared');
    } catch (e) {
      print('Failed to clear Hive boxes: $e');
      rethrow;
    }
  }
}
