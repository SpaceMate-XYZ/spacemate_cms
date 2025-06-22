import 'features/menu/data/models/menu_item_model_test.dart' as menu_item_model_test;
import 'features/menu/domain/entities/menu_item_entity_test.dart' as menu_item_entity_test;
import 'features/menu/domain/entities/menu_category_test.dart' as menu_category_test;

void main() {
  // Run all test groups
  menu_category_test.main();
  menu_item_entity_test.main();
  menu_item_model_test.main();
}
