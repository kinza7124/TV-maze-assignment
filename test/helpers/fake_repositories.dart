import 'package:flutter_application_1/core/entities/show.dart';
import 'package:flutter_application_1/core/network/api_exception.dart';
import 'package:flutter_application_1/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_application_1/features/search/domain/entities/person.dart';
import 'package:flutter_application_1/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_application_1/features/show_details/domain/entities/cast_member.dart';
import 'package:flutter_application_1/features/show_details/domain/entities/episode.dart';
import 'package:flutter_application_1/features/show_details/domain/repositories/show_details_repository.dart';
import 'package:flutter_application_1/features/watchlist/domain/repositories/watchlist_repository.dart';

import 'test_data.dart';

/// FAKE repositories: they implement the same abstract classes as the real
/// ones, but return data instantly without the internet. This is why the
/// BLoCs depend on the abstract repository and not on the real one.

class FakeHomeRepository implements HomeRepository {
  /// page number -> shows on that page. A missing page means "no more shows".
  final Map<int, List<Show>> pages;

  /// If set, getShows throws this error.
  Object? error;

  /// Every page the BLoC asked for (to check pagination).
  final List<int> requestedPages = [];

  FakeHomeRepository({this.pages = const {}, this.error});

  @override
  Future<List<Show>> getShows(int page) async {
    requestedPages.add(page);
    if (error != null) throw error!;
    return pages[page] ?? [];
  }
}

class FakeSearchRepository implements SearchRepository {
  /// Every query that really reached the "API" (to check debounce).
  final List<String> showQueries = [];

  @override
  Future<List<Show>> searchShows(String query) async {
    showQueries.add(query);
    if (query == 'error') throw const ApiException('No internet connection.');
    if (query == 'crash') throw Exception('unexpected');
    if (query == 'dark') return [dark];
    return [];
  }

  @override
  Future<List<Person>> searchPeople(String query) async {
    if (query == 'error') throw const ApiException('No internet connection.');
    if (query == 'bryan') return [bryan];
    return [];
  }
}

class FakeShowDetailsRepository implements ShowDetailsRepository {
  final List<CastMember> cast;
  final List<Episode> episodes;
  final bool failCast;

  FakeShowDetailsRepository({
    this.cast = castList,
    this.episodes = episodeList,
    this.failCast = false,
  });

  @override
  Future<Show> getShowDetails(int showId) async {
    if (showId == 404) {
      throw const ApiException('Server error (404). Please try again.');
    }
    return breakingBad;
  }

  @override
  Future<List<CastMember>> getCast(int showId) async {
    if (failCast) throw const ApiException('Could not load cast.');
    return cast;
  }

  @override
  Future<List<Episode>> getEpisodes(int showId) async => episodes;
}

/// Keeps the watchlist in memory instead of SharedPreferences.
class FakeWatchlistRepository implements WatchlistRepository {
  final List<Show> _shows;
  final bool failOnLoad;

  FakeWatchlistRepository({List<Show>? shows, this.failOnLoad = false})
    : _shows = [...?shows];

  @override
  Future<List<Show>> getWatchlist() async {
    if (failOnLoad) throw Exception('storage broken');
    return List.of(_shows);
  }

  @override
  Future<void> addShow(Show show) async {
    if (_shows.any((saved) => saved.id == show.id)) return;
    _shows.insert(0, show);
  }

  @override
  Future<void> removeShow(int showId) async {
    _shows.removeWhere((saved) => saved.id == showId);
  }

  @override
  Future<void> clearWatchlist() async => _shows.clear();
}
