import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/data/models/screen_model.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_local_data_source.dart';

class MockRemoteDataSource extends Mock implements MenuRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockLocalDataSource extends Mock implements MenuLocalDataSource {}

void main() {
  late MenuRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockNetworkInfo mockNetwork;
  late MockLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockNetwork = MockNetworkInfo();
    mockLocal = MockLocalDataSource();

    repository = MenuRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  group('getMenuGridsForUser', () {
    const sampleMenuItem = MenuItemModel(
      id: 1,
      label: 'Test',
      icon: 'test_icon',
      order: 1,
      isVisible: true,
      isAvailable: true,
      badgeCount: null,
      navigationTarget: '/test',
    );

    const sampleScreenModel = ScreenModel(
      id: 10,
      name: 'Home Screen',
      slug: 'home',
      title: 'Home',
      menuGrid: [sampleMenuItem],
    );

    test('returns ScreenEntity list when remote fetch succeeds and network available', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.getMenuGridsForUser(placeId: any(named: 'placeId'), authToken: any(named: 'authToken')))
          .thenAnswer((_) async => const Right([sampleScreenModel]));

      final result = await repository.getMenuGridsForUser(placeId: 'home', authToken: 'token');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (screens) {
          expect(screens.length, 1);
          final screen = screens.first;
          expect(screen.id, 10);
          expect(screen.menuGrid.first.label, 'Test');
        },
      );
    });

    test('returns NetworkFailure when offline', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await repository.getMenuGridsForUser(placeId: 'home', authToken: 'token');
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
