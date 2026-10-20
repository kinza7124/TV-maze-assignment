import '../../../../core/entities/show.dart';

/// REPOSITORY CONTRACT for the user's saved shows.
abstract class WatchlistRepository {
  Future<List<Show>> getWatchlist();
  Future<void> addShow(Show show);
  Future<void> removeShow(int showId);
  Future<void> clearWatchlist();
}
