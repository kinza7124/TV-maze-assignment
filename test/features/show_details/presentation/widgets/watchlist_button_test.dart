import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/show_details/presentation/widgets/watchlist_button.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  /// The details page buttons read the shared WatchlistBloc.
  Future<void> pumpButtons(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) =>
              WatchlistBloc(repository: FakeWatchlistRepository())
                ..add(const LoadWatchlist()),
          child: const Scaffold(
            body: Column(
              children: [
                WatchlistIconButton(show: breakingBad),
                WatchlistButton(show: breakingBad),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('adds the show, then removes it again', (tester) async {
    await pumpButtons(tester);
    expect(find.text('Add to Watchlist'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    // Add
    await tester.tap(find.text('Add to Watchlist'));
    await tester.pump();
    await tester.pump();
    expect(find.text('In Watchlist'), findsOneWidget);
    expect(find.text('Breaking Bad added to watchlist'), findsOneWidget);
    // The heart icon uses the same BLoC, so it updates too.
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    // Remove
    await tester.tap(find.text('In Watchlist'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Add to Watchlist'), findsOneWidget);
    expect(find.text('Breaking Bad removed from watchlist'), findsOneWidget);
  });

  testWidgets('the heart icon also toggles the watchlist', (tester) async {
    await pumpButtons(tester);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(find.text('In Watchlist'), findsOneWidget);
  });
}
