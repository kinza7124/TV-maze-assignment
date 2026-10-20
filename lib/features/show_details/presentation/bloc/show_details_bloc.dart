import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/show.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/episode.dart';
import '../../domain/repositories/show_details_repository.dart';
import 'show_details_event.dart';
import 'show_details_state.dart';

class ShowDetailsBloc extends Bloc<ShowDetailsEvent, ShowDetailsState> {
  final ShowDetailsRepository repository;

  ShowDetailsBloc({required this.repository})
    : super(const ShowDetailsLoading()) {
    on<LoadShowDetails>(_onLoadShowDetails);
    on<SeasonSelected>(_onSeasonSelected);
  }

  Future<void> _onLoadShowDetails(
    LoadShowDetails event,
    Emitter<ShowDetailsState> emit,
  ) async {
    emit(const ShowDetailsLoading());
    try {
      // Run all 3 API calls at the same time (faster than one by one).
      // If any of them fails, Future.wait throws and we go to catch.
      final results = await Future.wait([
        repository.getShowDetails(event.showId),
        repository.getCast(event.showId),
        repository.getEpisodes(event.showId),
      ]);

      final show = results[0] as Show;
      final cast = results[1] as List<CastMember>;
      final episodes = results[2] as List<Episode>;

      emit(
        ShowDetailsLoaded(
          show: show,
          cast: cast,
          episodes: episodes,
          selectedSeason: episodes.isEmpty ? 1 : episodes.first.season,
        ),
      );
    } catch (error) {
      emit(ShowDetailsError(ApiException.messageFrom(error)));
    }
  }

  void _onSeasonSelected(SeasonSelected event, Emitter<ShowDetailsState> emit) {
    final currentState = state;
    if (currentState is ShowDetailsLoaded) {
      emit(currentState.copyWith(selectedSeason: event.season));
    }
  }
}
