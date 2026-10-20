import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:flutter_application_1/app/main_screen.dart';
import 'package:flutter_application_1/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_application_1/features/not_found/presentation/screens/not_found_screen.dart';
import 'package:flutter_application_1/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_repositories.dart';

void main() {
  /// The whole app routing, with fake BLoCs (MainScreen needs them).
  Future<void> pumpApp(WidgetTester tester, String url) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                HomeBloc(repository: FakeHomeRepository())
                  ..add(const FetchShows()),
          ),
          BlocProvider(
            create: (_) => SearchBloc(repository: FakeSearchRepository()),
          ),
          BlocProvider(
            create: (_) =>
                WatchlistBloc(repository: FakeWatchlistRepository())
                  ..add(const LoadWatchlist()),
          ),
        ],
        child: MaterialApp(
          initialRoute: url,
          onGenerateRoute: AppRouter.onGenerateRoute,
          onGenerateInitialRoutes: AppRouter.onGenerateInitialRoutes,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('"/" opens the MainScreen with the bottom tabs', (tester) async {
    await pumpApp(tester, '/');

    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('an unknown url opens the 404 page', (tester) async {
    await pumpApp(tester, '/abc');

    expect(find.byType(NotFoundScreen), findsOneWidget);
    expect(find.text('Page not found'), findsOneWidget);
    expect(find.text('The page "/abc" does not exist.'), findsOneWidget);
  });

  testWidgets('"Go to Home" on the 404 page opens the MainScreen', (
    tester,
  ) async {
    await pumpApp(tester, '/abc');

    await tester.tap(find.text('Go to Home'));
    await tester.pumpAndSettle();

    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.byType(NotFoundScreen), findsNothing);
  });

  testWidgets('bottom navigation switches between the tabs', (tester) async {
    await pumpApp(tester, '/');

    await tester.tap(find.text('Watchlist'));
    await tester.pumpAndSettle();
    expect(find.text('My Watchlist'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('TV Explorer'), findsOneWidget);
  });
}
