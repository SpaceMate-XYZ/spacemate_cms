# Coder Tasks for Theme System Implementation

## 1. Update Theme Service for Persistence
File: lib/core/theme/theme_service.dart

1. Add imports:
```dart
import 'package:shared_preferences/shared_preferences.dart';
```

2. Add theme persistence:
```dart
class ThemeService {
  final _themeController = StreamController<bool>.broadcast();
  
  Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode') ?? false;
    _themeController.add(isDark);
  }
  
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = !(prefs.getBool('dark_mode') ?? false);
    prefs.setBool('dark_mode', isDark);
    _themeController.add(isDark);
  }
}
```

## 2. Integrate Dynamic Color
File: lib/core/theme/app_theme.dart

1. Add imports:
```dart
import 'package:dynamic_color/dynamic_color.dart';
```

2. Update theme creation:
```dart
static ThemeData getTheme({required BuildContext context, bool isDark = false}) {
  final colorScheme = isDark 
    ? _darkColorScheme 
    : _getDynamicColorScheme(context, isDark);
  
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    // ...existing theme properties
  );
}
```

## 3. Create Theme Toggle Widget
File: lib/core/theme/theme_toggle.dart

1. Create new file with:
```dart
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:spacemate/core/theme/theme_service.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ThemeService().isDarkMode,
      builder: (context, snapshot) {
        final isDark = snapshot.data ?? false;
        return SwitchListTile(
          title: Text(isDark ? 'Dark Mode' : 'Light Mode'),
          value: isDark,
          onChanged: (value) => ThemeService().toggleTheme(),
        );
      },
    );
  }
}
```

## 4. Integrate Theme Toggle in UI
File: lib/features/menu/presentation/widgets/menu_bottom_nav_bar.dart

1. Add import:
```dart
import 'package:spacemate/core/theme/theme_toggle.dart';
```

2. Add toggle to drawer:
```dart
Drawer(
  child: ListView(
    children: [
      // ...existing items
      const ThemeToggle(),
      // ...other menu items
    ],
  ),
)
```

## 5. Update Main Application
File: lib/main.dart

1. Initialize theme service:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().initTheme(); // Add this line
  runApp(const MyApp());
}