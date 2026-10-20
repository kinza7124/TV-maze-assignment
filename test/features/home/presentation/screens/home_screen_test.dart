import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/network/api_exception.dart';
import 'package:flutter_application_1/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_application_1/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeHomeRepository repository;
  var searchTapped = false;

  setUp(() {
    searchTapped = false;
    repository = FakeHomeRepository(
      pages: {
        0: [breakingBad, dark],
      },
    );
  });

  /// Shows the HomeScreen with a HomeBloc that uses the fake repository.
  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) =>
              HomeBloc(repository: repository)..add(const FetchShows()),
          child: HomeScreen(
            onSearchTap: () => searchTapped = true,
            onSettingsTap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows both sections with the loaded shows', (tester) async {
    await pumpHome(tester);

    expect(find.text('Trending Now'), findsOneWidget);
    expect(find.text('Popular Shows'), findsOneWidget);
    // Each show appears in both rows.
    expect(find.text('Breaking Bad'), findsNWidgets(2));
    expect(find.text('Dark'), findsNWidgets(2));
  });

  testWidgets('tapping the search bar calls onSearchTap', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.text('Search shows...'));

    expect(searchTapped, isTrue);
  });

  testWidgets('shows the empty state when the API has no shows', (
    tester,
  ) async {
    repository = FakeHomeRepository();
    await pumpHome(tester);

    expect(find.text('No shows found'), findsOneWidget);
  });

  testWidgets('shows the error and loads again after "Try Again"', (
    tester,
  ) async {
    repository.error = const ApiException('No internet connection.');
    await pumpHome(tester);

    expect(find.text('No internet connection.'), findsOneWidget);

    // Internet is back -> retry works.
    repository.error = null;
    await tester.tap(find.text('Try Again'));
    await tester.pumpAndSettle();

    expect(find.text('Trending Now'), findsOneWidget);
  });
}
