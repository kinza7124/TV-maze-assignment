import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/watchlist_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

/// This BLoC is created once at app start (in app.dart), so the
/// Details screen and the Watchlist screen share the same data.
class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository repository;

  WatchlistBloc({required this.repository}) : super(const WatchlistLoading()) {
    on<LoadWatchlist>(_onLoad);
    on<AddToWatchlist>(_onAdd);
    on<RemoveFromWatchlist>(_onRemove);
    on<ClearWatchlist>(_onClear);
  }

  Future<void> _onLoad(
    LoadWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      emit(WatchlistLoaded(await repository.getWatchlist()));
    } catch (_) {
      emit(const WatchlistError('Could not load your watchlist.'));
    }
  }

  Future<void> _onAdd(
    AddToWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    await repository.addShow(event.show);
    emit(WatchlistLoaded(await repository.getWatchlist()));
  }

  Future<void> _onRemove(
    RemoveFromWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    await repository.removeShow(event.showId);
    emit(WatchlistLoaded(await repository.getWatchlist()));
  }

  Future<void> _onClear(
    ClearWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    await repository.clearWatchlist();
    emit(const WatchlistLoaded([]));
  }
}
