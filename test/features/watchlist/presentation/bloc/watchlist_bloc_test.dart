import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:flutter_application_1/features/watchlist/presentation/bloc/watchlist_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  test('initial state is WatchlistLoading', () {
    expect(
      WatchlistBloc(repository: FakeWatchlistRepository()).state,
      const WatchlistLoading(),
    );
  });

  group('LoadWatchlist', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'emits the saved shows',
      build: () => WatchlistBloc(
        repository: FakeWatchlistRepository(shows: [breakingBad]),
      ),
      act: (bloc) => bloc.add(const LoadWatchlist()),
      expect: () => [
        const WatchlistLoaded([breakingBad]),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'emits an empty list when nothing is saved (empty state)',
      build: () => WatchlistBloc(repository: FakeWatchlistRepository()),
      act: (bloc) => bloc.add(const LoadWatchlist()),
      expect: () => [const WatchlistLoaded([])],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'emits Error when the storage cannot be read',
      build: () => WatchlistBloc(
        repository: FakeWatchlistRepository(failOnLoad: true),
      ),
      act: (bloc) => bloc.add(const LoadWatchlist()),
      expect: () => [const WatchlistError('Could not load your watchlist.')],
    );
  });

  blocTest<WatchlistBloc, WatchlistState>(
    'AddToWatchlist puts the new show on top',
    build: () => WatchlistBloc(
      repository: FakeWatchlistRepository(shows: [breakingBad]),
    ),
    act: (bloc) => bloc.add(const AddToWatchlist(dark)),
    expect: () => [
      const WatchlistLoaded([dark, breakingBad]),
    ],
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'RemoveFromWatchlist removes the show',
    build: () => WatchlistBloc(
      repository: FakeWatchlistRepository(shows: [dark, breakingBad]),
    ),
    act: (bloc) => bloc.add(RemoveFromWatchlist(dark.id)),
    expect: () => [
      const WatchlistLoaded([breakingBad]),
    ],
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'ClearWatchlist removes every show',
    build: () => WatchlistBloc(
      repository: FakeWatchlistRepository(shows: [dark, breakingBad]),
    ),
    act: (bloc) => bloc.add(const ClearWatchlist()),
    expect: () => [const WatchlistLoaded([])],
  );

  test('WatchlistLoaded.isInWatchlist checks by show id', () {
    const state = WatchlistLoaded([breakingBad]);

    expect(state.isInWatchlist(breakingBad.id), isTrue);
    expect(state.isInWatchlist(dark.id), isFalse);
  });
}
