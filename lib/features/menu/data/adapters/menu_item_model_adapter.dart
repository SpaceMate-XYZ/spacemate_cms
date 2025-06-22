import 'package:hive/hive.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

class MenuItemModelAdapter extends TypeAdapter<MenuItemModel> {
  @override
  final int typeId = 0; // Unique ID for this adapter

  @override
  MenuItemModel read(BinaryReader reader) {
    return MenuItemModel(
      id: reader.readString(),
      title: reader.readString(),
      icon: reader.readString(),
      category: MenuCategoryX.fromString(reader.readString()),
      route: reader.readString(),
      isActive: reader.readBool(),
      order: reader.readInt(),
      badgeCount: reader.readInt(),
      requiredPermissions: (reader.read() as List).cast<String>(),
      analyticsId: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, MenuItemModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.icon);
    writer.writeString(obj.category.toString());
    writer.writeString(obj.route);
    writer.writeBool(obj.isActive);
    writer.writeInt(obj.order ?? -1);
    writer.writeInt(obj.badgeCount);
    writer.write(obj.requiredPermissions);
    writer.writeString(obj.analyticsId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
