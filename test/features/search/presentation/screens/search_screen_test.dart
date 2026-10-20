import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_application_1/features/search/presentation/screens/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  late FakeSearchRepository repository;

  setUp(() => repository = FakeSearchRepository());

  Future<void> pumpSearch(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => SearchBloc(repository: repository),
          child: const SearchScreen(),
        ),
      ),
    );
  }

  /// Types [text] and waits for the 500 ms debounce + the fake API.
  Future<void> typeAndWait(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the hint before the user types', (tester) async {
    await pumpSearch(tester);

    expect(find.text('Search TV Shows'), findsOneWidget);
    expect(find.text('Shows'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
  });

  testWidgets('shows results from the API', (tester) async {
    await pumpSearch(tester);

    await typeAndWait(tester, 'dark');

    expect(find.text('Dark'), findsOneWidget);
    expect(repository.showQueries, ['dark']);
  });

  testWidgets('shows "No results found" when nothing matches', (tester) async {
    await pumpSearch(tester);

    await typeAndWait(tester, 'zzzz');

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('shows the error with a Try Again button', (tester) async {
    await pumpSearch(tester);

    await typeAndWait(tester, 'error');

    expect(find.text('No internet connection.'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('the People tab searches people', (tester) async {
    await pumpSearch(tester);

    await typeAndWait(tester, 'bryan');
    await tester.tap(find.text('People'));
    await tester.pumpAndSettle();

    expect(find.text('Bryan Cranston'), findsOneWidget);
  });

  testWidgets('the clear (X) button empties the field', (tester) async {
    await pumpSearch(tester);
    await typeAndWait(tester, 'dark');

    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Search TV Shows'), findsOneWidget);
    expect(find.byIcon(Icons.cancel), findsNothing);
  });
}
