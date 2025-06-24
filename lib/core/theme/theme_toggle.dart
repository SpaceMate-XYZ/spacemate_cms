import 'package:flutter/material.dart';
import 'package:spacemate/core/theme/theme_service.dart';
import 'package:spacemate/core/di/injection_container.dart' as di;

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: di.sl<ThemeService>().isDarkMode,
      builder: (context, snapshot) {
        final isDark = snapshot.data ?? false;
        return Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.height * 0.02, // 2% of screen height
          ),
          child: IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.black : Colors.white, // Black for dark theme, white for light theme
            ),
            onPressed: () {
              di.sl<ThemeService>().toggleTheme();
            },
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        );
      },
    );
  }
}