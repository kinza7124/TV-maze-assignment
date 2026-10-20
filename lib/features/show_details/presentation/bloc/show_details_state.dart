import 'package:equatable/equatable.dart';

import '../../../../core/entities/show.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/episode.dart';

abstract class ShowDetailsState extends Equatable {
  const ShowDetailsState();

  @override
  List<Object?> get props => [];
}

class ShowDetailsLoading extends ShowDetailsState {
  const ShowDetailsLoading();
}

class ShowDetailsLoaded extends ShowDetailsState {
  final Show show;
  final List<CastMember> cast;
  final List<Episode> episodes;
  final int selectedSeason;

  const ShowDetailsLoaded({
    required this.show,
    required this.cast,
    required this.episodes,
    required this.selectedSeason,
  });

  /// All season numbers, e.g. [1, 2, 3, 4, 5]
  List<int> get seasons {
    final seasonSet = episodes.map((episode) => episode.season).toSet();
    return seasonSet.toList()..sort();
  }

  /// Episodes GROUPED BY SEASON: only the episodes of one season.
  List<Episode> episodesOfSeason(int season) {
    return episodes.where((episode) => episode.season == season).toList();
  }

  ShowDetailsLoaded copyWith({int? selectedSeason}) {
    return ShowDetailsLoaded(
      show: show,
      cast: cast,
      episodes: episodes,
      selectedSeason: selectedSeason ?? this.selectedSeason,
    );
  }

  @override
  List<Object?> get props => [show, cast, episodes, selectedSeason];
}

class ShowDetailsError extends ShowDetailsState {
  final String message;

  const ShowDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
