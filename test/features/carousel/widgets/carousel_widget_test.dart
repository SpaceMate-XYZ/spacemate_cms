import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:spacemate/features/carousel/presentation/widgets/carousel_widget.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';
import 'package:spacemate/features/carousel/domain/entities/carousel_item_entity.dart';

class MockCarouselBloc extends Mock implements CarouselBloc {}

void main() {
  testWidgets('CarouselWidget shows loading state', (tester) async {
    final bloc = MockCarouselBloc();
    final state = CarouselLoading();
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream<CarouselState>.fromIterable([state]), initialState: state);

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<CarouselBloc>.value(
        value: bloc,
        child: const CarouselWidget(),
      ),
    ));

    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('CarouselWidget shows items when loaded', (tester) async {
    final bloc = MockCarouselBloc();
    const item = CarouselItemEntity(
      id: '1',
      title: 'T',
      imageUrl: 'https://example.com/img.png',
    );
    final state = CarouselLoaded(items: [item]);
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream<CarouselState>.fromIterable([state]), initialState: state);

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<CarouselBloc>.value(
        value: bloc,
        child: const CarouselWidget(),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
  });

  testWidgets('CarouselWidget shows error message', (tester) async {
    final bloc = MockCarouselBloc();
    const state = CarouselError(message: 'oops');
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream<CarouselState>.fromIterable([state]), initialState: state);

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<CarouselBloc>.value(
        value: bloc,
        child: const CarouselWidget(),
      ),
    ));

    expect(find.text('oops'), findsOneWidget);
  });
}
