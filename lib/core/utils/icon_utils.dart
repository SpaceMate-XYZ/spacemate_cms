import 'package:flutter/material.dart';

/// A utility class for handling icons throughout the application.
class IconUtils {
  /// A map that associates string keys with their corresponding [IconData].
  /// This allows for dynamic icon selection based on data from an API or CMS.
  static final Map<String, IconData> _iconMap = {
    'home': Icons.home_rounded,
    'explore': Icons.explore_rounded,
    'map': Icons.map_rounded,
    'settings': Icons.settings_rounded,
    'person': Icons.person_rounded,
    'info': Icons.info_outline_rounded,
    'help': Icons.help_outline_rounded,
    'search': Icons.search_rounded,
    'favorite': Icons.favorite_rounded,
    'favorite_border': Icons.favorite_border_rounded,
    'star': Icons.star_rounded,
    'star_border': Icons.star_border_rounded,
    'visibility': Icons.visibility_rounded,
    'visibility_off': Icons.visibility_off_rounded,
    'check_circle': Icons.check_circle_rounded,
    'cancel': Icons.cancel_rounded,
    'add': Icons.add_rounded,
    'remove': Icons.remove_rounded,
    'edit': Icons.edit_rounded,
    'delete': Icons.delete_rounded,
    'menu': Icons.menu_rounded,
    'arrow_back': Icons.arrow_back_ios_rounded,
    'arrow_forward': Icons.arrow_forward_ios_rounded,
    'more_vert': Icons.more_vert_rounded,
    'more_horiz': Icons.more_horiz_rounded,
    'default': Icons.help_outline_rounded, // Default icon
  };

  /// Retrieves [IconData] for a given icon name string.
  ///
  /// If the [iconName] is null or not found in the map, it returns a default icon.
  /// This prevents rendering errors if the CMS provides an invalid icon name.
  static IconData? getIconData(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return _iconMap['default'];
    }
    return _iconMap[iconName.toLowerCase()] ?? _iconMap['default'];
  }
}
