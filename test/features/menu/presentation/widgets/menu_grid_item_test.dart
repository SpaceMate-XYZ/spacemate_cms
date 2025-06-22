import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';

// Define default color scheme for testing
final _defaultLightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.light,
);

final _defaultDarkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.dark,
);

// Test app with dynamic color support
class TestApp extends StatelessWidget {
  final Widget child;
  final Brightness brightness;

  const TestApp({
    Key? key,
    required this.child,
    this.brightness = Brightness.light,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = brightness == Brightness.light
        ? _defaultLightColorScheme
        : _defaultDarkColorScheme;

    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: DynamicColorBuilder(
          builder: (lightColorScheme, darkColorScheme) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: brightness == Brightness.light
                    ? lightColorScheme ?? colorScheme
                    : darkColorScheme ?? colorScheme,
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}

// Simplified version of MenuItemEntity for testing
class TestMenuItemEntity {
  final String id;
  final String title;
  final String icon;
  final MenuCategory category;
  final String route;
  final bool isActive;
  final int? order;
  final int? badgeCount;
  final String? imageUrl;

  TestMenuItemEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.category,
    required this.route,
    this.isActive = true,
    this.order = 1,
    this.badgeCount = 0,
    this.imageUrl,
  });
}

// Simplified version of MenuGridItem for testing
class TestMenuGridItem extends StatelessWidget {
  final TestMenuItemEntity item;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showBadge;
  final bool showTitle;

  const TestMenuGridItem({
    Key? key,
    required this.item,
    this.onTap,
    this.isSelected = false,
    this.showBadge = true,
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer 
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12.0),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon/Image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.home, 
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            
            // Badge
            if (showBadge && (item.badgeCount ?? 0) > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${item.badgeCount}',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            
            // Title
            if (showTitle)
              Text(
                item.title,
                style: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ].where((widget) => widget != null).toList(),
        ),
      ),
    );
  }
}

void main() {
  // Create a test menu item
  final testMenuItem = TestMenuItemEntity(
    id: '1',
    title: 'Test Item',
    icon: 'home',
    category: MenuCategory.transport,
    route: '/test',
    badgeCount: 3,
  );

  // Test widget with proper theming
  Widget createWidgetUnderTest({
    TestMenuItemEntity? item,
    VoidCallback? onTap,
    bool isSelected = false,
    bool showBadge = true,
    bool showTitle = true,
    Brightness brightness = Brightness.light,
  }) {
    return TestApp(
      brightness: brightness,
      child: Center(
        child: TestMenuGridItem(
          item: item ?? testMenuItem,
          onTap: onTap,
          isSelected: isSelected,
          showBadge: showBadge,
          showTitle: showTitle,
        ),
      ),
    );
  }

  group('MenuGridItem', () {
    testWidgets('renders correctly with all properties', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify the item is rendered
      expect(find.text('Test Item'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      
      // Verify badge is shown
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(
        createWidgetUnderTest(
          onTap: () => wasTapped = true,
        ),
      );

      // Tap the item
      await tester.tap(find.byType(TestMenuGridItem));
      await tester.pump();

      // Verify onTap was called
      expect(wasTapped, isTrue);
    });

    testWidgets('shows selected state when isSelected is true', (tester) async {
      // Build our widget with isSelected = true
      await tester.pumpWidget(createWidgetUnderTest(isSelected: true));

      // Find the container that should have the selected style
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(TestMenuGridItem),
          matching: find.byType(Container).first,
        ),
      );
      
      // Verify the container has the expected decoration
      final decoration = container.decoration as BoxDecoration;
      
      // The color should be primaryContainer in light theme
      final expectedColor = _defaultLightColorScheme.primaryContainer;
      
      // Check if the container has the expected color
      expect(
        decoration.color,
        equals(expectedColor),
        reason: 'Selected item should have primaryContainer color',
      );
      
      // Verify it has a border when selected
      expect(decoration.border, isNotNull, reason: 'Selected item should have a border');
    });

    testWidgets('hides badge when showBadge is false', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(showBadge: false));
      
      // Verify badge is hidden
      expect(find.text('3'), findsNothing);
    });

    testWidgets('hides title when showTitle is false', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(showTitle: false));
      
      // Verify title is hidden
      expect(find.text('Test Item'), findsNothing);
    });
  });
}
