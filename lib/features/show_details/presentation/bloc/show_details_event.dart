import 'package:equatable/equatable.dart';

abstract class ShowDetailsEvent extends Equatable {
  const ShowDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Load show info + cast + episodes.
class LoadShowDetails extends ShowDetailsEvent {
  final int showId;

  const LoadShowDetails(this.showId);

  @override
  List<Object?> get props => [showId];
}

/// User picked a season from the dropdown in the Episodes tab.
class SeasonSelected extends ShowDetailsEvent {
  final int season;

  const SeasonSelected(this.season);

  @override
  List<Object?> get props => [season];
}
