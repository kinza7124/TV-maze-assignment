import 'package:flutter_application_1/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:flutter_application_1/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/test_data.dart';

void main() {
  late SharedPreferences prefs;
  late WatchlistRepositoryImpl repository;

  setUp(() async {
    // A fake, empty SharedPreferences that lives in memory.
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = WatchlistRepositoryImpl(
      localDataSource: WatchlistLocalDataSource(prefs: prefs),
    );
  });

  test('starts with an empty watchlist', () async {
    expect(await repository.getWatchlist(), isEmpty);
  });

  test('addShow saves the show with all its data', () async {
    await repository.addShow(breakingBad);

    final saved = await repository.getWatchlist();
    expect(saved.single.name, 'Breaking Bad');
    expect(saved.single.rating, 9.2);
    expect(saved.single.genres, ['Drama', 'Crime', 'Thriller']);
  });

  test('the newest show is on top', () async {
    await repository.addShow(breakingBad);
    await repository.addShow(dark);

    final saved = await repository.getWatchlist();
    expect(saved.map((s) => s.name), ['Dark', 'Breaking Bad']);
  });

  test('the same show is not added twice', () async {
    await repository.addShow(breakingBad);
    await repository.addShow(breakingBad);

    expect(await repository.getWatchlist(), hasLength(1));
  });

  test('removeShow removes only that show', () async {
    await repository.addShow(breakingBad);
    await repository.addShow(dark);

    await repository.removeShow(breakingBad.id);

    final saved = await repository.getWatchlist();
    expect(saved.map((s) => s.name), ['Dark']);
  });

  test('clearWatchlist removes every show', () async {
    await repository.addShow(breakingBad);
    await repository.addShow(dark);

    await repository.clearWatchlist();

    expect(await repository.getWatchlist(), isEmpty);
  });

  test('saved shows are still there after an app restart', () async {
    await repository.addShow(breakingBad);

    // "Restart": create brand new objects that read the same storage.
    final afterRestart = WatchlistRepositoryImpl(
      localDataSource: WatchlistLocalDataSource(prefs: prefs),
    );

    final saved = await afterRestart.getWatchlist();
    expect(saved.single.name, 'Breaking Bad');
  });

  test('shows are stored as JSON strings under "watchlist_shows"', () async {
    await repository.addShow(dark);

    final stored = prefs.getStringList('watchlist_shows');
    expect(stored, hasLength(1));
    expect(stored!.single, contains('"name":"Dark"'));
  });
}
