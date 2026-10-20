import 'package:equatable/equatable.dart';

import '../../../../core/entities/show.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

/// Saved shows. If [shows] is empty the UI shows the empty state.
class WatchlistLoaded extends WatchlistState {
  final List<Show> shows;

  const WatchlistLoaded(this.shows);

  bool isInWatchlist(int showId) => shows.any((show) => show.id == showId);

  @override
  List<Object?> get props => [shows];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
