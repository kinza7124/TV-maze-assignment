import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/empty_view.dart';
import 'package:flutter_application_1/core/widgets/error_view.dart';
import 'package:flutter_application_1/core/widgets/genre_chip.dart';
import 'package:flutter_application_1/core/widgets/loading_view.dart';
import 'package:flutter_application_1/core/widgets/poster_image.dart';
import 'package:flutter_application_1/core/widgets/show_list_tile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';

/// Puts a widget inside a MaterialApp + Scaffold so it can be drawn.
Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('LoadingView shows a spinner', (tester) async {
    await tester.pumpWidget(wrap(const LoadingView()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ErrorView shows the message and calls onRetry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      wrap(ErrorView(message: 'No internet', onRetry: () => retried = true)),
    );

    expect(find.text('No internet'), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    expect(retried, isTrue);
  });

  testWidgets('EmptyView shows a button only when buttonText is given', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const EmptyView(
          icon: Icons.search_off,
          title: 'No results found',
          message: 'Try another name',
        ),
      ),
    );
    expect(find.text('No results found'), findsOneWidget);
    expect(find.text('Try another name'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);

    var pressed = false;
    await tester.pumpWidget(
      wrap(
        EmptyView(
          icon: Icons.tv,
          title: 'Empty',
          message: '',
          buttonText: 'Explore',
          onButtonPressed: () => pressed = true,
        ),
      ),
    );
    await tester.tap(find.text('Explore'));
    expect(pressed, isTrue);
  });

  testWidgets('GenreChip shows its label', (tester) async {
    await tester.pumpWidget(wrap(const GenreChip(label: 'Drama')));
    expect(find.text('Drama'), findsOneWidget);
  });

  testWidgets('PosterImage shows a placeholder icon when the url is null', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const PosterImage(imageUrl: null, placeholderIcon: Icons.person)),
    );
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  group('ShowListTile', () {
    testWidgets('shows name, years and genres and reacts to taps', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(ShowListTile(show: breakingBad, onTap: () => tapped = true)),
      );

      expect(find.text('Breaking Bad'), findsOneWidget);
      expect(find.text('2008 - 2013'), findsOneWidget);
      expect(find.text('Drama, Crime, Thriller'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);

      await tester.tap(find.text('Breaking Bad'));
      expect(tapped, isTrue);
    });

    testWidgets('uses the custom trailing widget when given', (tester) async {
      await tester.pumpWidget(
        wrap(
          ShowListTile(
            show: breakingBad,
            onTap: () {},
            trailing: const Icon(Icons.favorite),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });
  });
}
