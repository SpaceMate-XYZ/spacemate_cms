import 'package:flutter/material.dart'; // Changed to material.dart
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_symbols_icons/symbols_map.dart';

/// A utility class for mapping string names from a CMS/API to Flutter's [IconData].
/// It uses the material_symbols_icons package to dynamically look up icons.
class IconUtils {
  // This is a private constructor, as this class is not meant to be instantiated.
  IconUtils._();

  /// Retrieves [IconData] for a given icon name string from the backend.
  ///
  /// It sanitizes the input name and returns a default icon if the name is null,
  /// empty, or not found. This prevents rendering errors.
  static IconData getIconData(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return Icons.help_outline; // Default icon from Icons
    }

    String processedName = iconName;
    if (processedName.startsWith('MaterialSymbols.')) {
      processedName = processedName.substring(16); // Corrected substring index
    }

    // Sanitize the key: convert to lowercase and replace dashes with underscores.
    final key = processedName.toLowerCase().replaceAll('-', '_');

    // Look up the IconData directly from the map provided by the package.
    final IconData? iconData = materialSymbolsMap[key] ?? materialSymbolsMap['${key}_filled'];

    // Return the found icon, or a default one if not found.
    return iconData ?? Symbols.help;
  }
}
