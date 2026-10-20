import 'package:equatable/equatable.dart';

import '../../../../core/entities/show.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

/// Read saved shows from storage (when the app starts).
class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();
}

class AddToWatchlist extends WatchlistEvent {
  final Show show;

  const AddToWatchlist(this.show);

  @override
  List<Object?> get props => [show];
}

class RemoveFromWatchlist extends WatchlistEvent {
  final int showId;

  const RemoveFromWatchlist(this.showId);

  @override
  List<Object?> get props => [showId];
}

/// Remove every show.
class ClearWatchlist extends WatchlistEvent {
  const ClearWatchlist();
}
