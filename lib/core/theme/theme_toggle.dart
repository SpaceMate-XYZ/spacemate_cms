import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacemate/core/theme/theme_service.dart';

/// A widget that provides a button to toggle between light, dark, and system theme modes.
///
/// This widget uses `Provider` to access and interact with the `ThemeService`,
/// allowing users to change the application's theme preference.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();

    IconData iconData;
    String tooltip;

    switch (themeService.themeMode) {
      case ThemeMode.light:
        iconData = Icons.light_mode;
        tooltip = 'Switch to Dark Mode';
        break;
      case ThemeMode.dark:
        iconData = Icons.dark_mode;
        tooltip = 'Switch to System Theme';
        break;
      case ThemeMode.system:
        iconData = Icons.settings_brightness;
        tooltip = 'Switch to Light Mode';
        break;
    }

    return IconButton(
      icon: Icon(iconData),
      tooltip: tooltip,
      onPressed: () {
        themeService.toggleTheme();
      },
    );
  }
}
