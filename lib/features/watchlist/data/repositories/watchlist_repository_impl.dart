import '../../../../core/entities/show.dart';
import '../../../../core/models/show_model.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_local_data_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Show>> getWatchlist() async {
    return localDataSource.getWatchlist();
  }

  @override
  Future<void> addShow(Show show) async {
    final shows = localDataSource.getWatchlist();
    // Don't add the same show twice.
    if (shows.any((saved) => saved.id == show.id)) return;
    shows.insert(0, ShowModel.fromEntity(show)); // newest on top
    await localDataSource.saveWatchlist(shows);
  }

  @override
  Future<void> removeShow(int showId) async {
    final shows = localDataSource.getWatchlist();
    shows.removeWhere((saved) => saved.id == showId);
    await localDataSource.saveWatchlist(shows);
  }

  @override
  Future<void> clearWatchlist() async {
    await localDataSource.saveWatchlist([]);
  }
}
