import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/features/menu/presentation/pages/facilities_page.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/domain/entities/screen_entity.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid.dart';
import '../../../../helpers/test_setup.dart';

class MockMenuBloc extends Mock implements MenuBloc {}

void main() {
  late MockMenuBloc mockMenuBloc;

  setUpAll(() {
    TestSetup.initializeTestDI();
  registerFallbackValue(const LoadMenuGridsEvent(placeId: 'home'));
  });

  setUp(() {
    mockMenuBloc = MockMenuBloc();
  // stub state/stream when needed in each test
  });

  testWidgets('FacilitiesPage shows MenuGrid when data available and dispatches LoadMenuGridsEvent', (tester) async {
    final state = const MenuState.initial().copyWith(
      status: MenuStatus.success,
      screens: [
        const ScreenEntity(id: 1, name: 'Facilities', slug: 'facilities', title: 'Facilities', menuGrid: []),
      ],
    );

  when(() => mockMenuBloc.state).thenReturn(state);
  when(() => mockMenuBloc.stream).thenAnswer((_) => Stream<MenuState>.value(state));

  await tester.pumpWidget(TestSetup.createTestApp(child: const FacilitiesPage(), menuBloc: mockMenuBloc));
    await tester.pumpAndSettle();

    expect(find.byType(MenuGrid), findsOneWidget);
    verify(() => mockMenuBloc.add(any())).called(greaterThanOrEqualTo(1));
  });
}
