import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spacemate/main.dart' as app;
import 'package:spacemate/features/menu/presentation/pages/home_page.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid_item.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/screen_entity.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Reset singletons and seed deterministic data before each test
  setUp(() async {
    await GetIt.I.reset();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Minimal seeded menu items JSON expected by the local data source cache
    const seededMenuItemsJson = '''[
      {
        "id": 1,
        "attributes": {
          "label": "Test Label",
          "icon": "",
          "order": 1,
          "is_visible": true,
          "is_available": true,
          "badge_count": 0,
          "navigationTarget": "/test-route"
        }
      }
    ]''';

    SharedPreferences.setMockInitialValues({
      'menu_cache_data_home': seededMenuItemsJson,
      'menu_cache_meta_home': '{"timestamp": ${DateTime.now().millisecondsSinceEpoch}}',
    });

    // Register a fake NetworkInfo that reports offline so repository will use cached data
    GetIt.I.registerLazySingleton<NetworkInfo>(() => _FakeNetworkInfo(connected: false));

  // Register a fake MenuRepository so DI doesn't override it during init()
  GetIt.I.registerLazySingleton<MenuRepository>(() => _FakeMenuRepository(seededMenuItemsJson));
  });

  testWidgets('Menu loads, displays items and supports scroll', (tester) async {
    // Start the app once for this test
    app.main();
    await tester.pumpAndSettle();

    // Wait up to ~5s for the MenuGridItem to appear (polling)
    bool foundItems = false;
    for (int i = 0; i < 20; i++) {
      if (find.byType(MenuGridItem).evaluate().isNotEmpty) {
        foundItems = true;
        break;
      }
      await tester.pump(const Duration(milliseconds: 250));
    }

    // Final settle
    await tester.pumpAndSettle();

    // Verify the menu page is displayed
    expect(find.byType(HomePage), findsOneWidget);

  // Verify menu items loaded from seeded cache
  expect(find.byType(CircularProgressIndicator), findsNothing);
  expect(foundItems, isTrue, reason: 'MenuGridItem widgets never appeared');

    // Verify grid exists and can be scrolled
    final gridView = find.byType(GridView);
    expect(gridView, findsOneWidget);
    await tester.fling(gridView, const Offset(0, -300), 800);
    await tester.pumpAndSettle();
  });
}

class _FakeNetworkInfo implements NetworkInfo {
  final bool connected;
  _FakeNetworkInfo({required this.connected});

  @override
  Future<bool> get isConnected async => connected;

  @override
  Future<ConnectivityResult> get connectivityResult async =>
      connected ? ConnectivityResult.wifi : ConnectivityResult.none;

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => const Stream.empty();
}



class _FakeMenuRepository implements MenuRepository {
  final String seededJson;
  _FakeMenuRepository(this.seededJson);

  @override
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItems({String? placeId}) async {
    try {
      final List decoded = json.decode(seededJson) as List;
      final items = decoded.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>)).toList();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSupportedLocales({String? placeId}) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<ScreenEntity>>> getMenuGridsForUser({String? placeId, String? authToken}) async {
    try {
      final List decoded = json.decode(seededJson) as List;
      final items = decoded.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>)).toList();
      final screen = ScreenEntity(id: 1, name: 'Home', slug: 'home', title: 'Home', menuGrid: items);
      return Right([screen]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
