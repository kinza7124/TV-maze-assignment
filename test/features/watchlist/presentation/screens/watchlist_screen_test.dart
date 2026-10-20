import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/entities/show.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:flutter_application_1/features/watchlist/presentation/screens/watchlist_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  var exploreTapped = false;

  setUp(() => exploreTapped = false);

  Future<void> pumpWatchlist(WidgetTester tester, List<Show> saved) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => WatchlistBloc(
            repository: FakeWatchlistRepository(shows: saved),
          )..add(const LoadWatchlist()),
          child: WatchlistScreen(onExploreTap: () => exploreTapped = true),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('empty watchlist shows the empty state', (tester) async {
    await pumpWatchlist(tester, []);

    expect(find.text('Your watchlist is empty'), findsOneWidget);
    // The "clear all" button is hidden when there is nothing to clear.
    expect(find.byIcon(Icons.delete_outline), findsNothing);

    await tester.tap(find.text('Explore Shows'));
    expect(exploreTapped, isTrue);
  });

  testWidgets('shows every saved show', (tester) async {
    await pumpWatchlist(tester, [breakingBad, dark]);

    expect(find.text('My Watchlist'), findsOneWidget);
    expect(find.text('Breaking Bad'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });

  testWidgets('the heart button removes a show and shows a SnackBar', (
    tester,
  ) async {
    await pumpWatchlist(tester, [breakingBad]);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump(); // let the BLoC handle the event
    await tester.pump(); // let the SnackBar appear

    expect(find.text('Breaking Bad removed from watchlist'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Your watchlist is empty'), findsOneWidget);
  });

  testWidgets('"Clear all" asks first, then removes everything', (
    tester,
  ) async {
    await pumpWatchlist(tester, [breakingBad, dark]);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Clear watchlist?'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(find.text('Your watchlist is empty'), findsOneWidget);
  });

  testWidgets('"Cancel" in the dialog keeps the shows', (tester) async {
    await pumpWatchlist(tester, [breakingBad]);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Breaking Bad'), findsOneWidget);
  });
}
