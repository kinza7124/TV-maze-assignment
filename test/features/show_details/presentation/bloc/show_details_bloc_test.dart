import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_application_1/features/show_details/domain/entities/episode.dart';
import 'package:flutter_application_1/features/show_details/presentation/bloc/show_details_bloc.dart';
import 'package:flutter_application_1/features/show_details/presentation/bloc/show_details_event.dart';
import 'package:flutter_application_1/features/show_details/presentation/bloc/show_details_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  const loaded = ShowDetailsLoaded(
    show: breakingBad,
    cast: castList,
    episodes: episodeList,
    selectedSeason: 1,
  );

  test('initial state is ShowDetailsLoading', () {
    expect(
      ShowDetailsBloc(repository: FakeShowDetailsRepository()).state,
      const ShowDetailsLoading(),
    );
  });

  group('LoadShowDetails', () {
    blocTest<ShowDetailsBloc, ShowDetailsState>(
      'emits Loaded with show, cast and episodes (season 1 selected)',
      build: () => ShowDetailsBloc(repository: FakeShowDetailsRepository()),
      act: (bloc) => bloc.add(const LoadShowDetails(169)),
      expect: () => [const ShowDetailsLoading(), loaded],
    );

    blocTest<ShowDetailsBloc, ShowDetailsState>(
      'selects the first season that exists (e.g. a show starting at season 3)',
      build: () => ShowDetailsBloc(
        repository: FakeShowDetailsRepository(
          episodes: const [Episode(id: 9, name: 'Ep', season: 3)],
        ),
      ),
      act: (bloc) => bloc.add(const LoadShowDetails(169)),
      skip: 1, // skip ShowDetailsLoading
      expect: () => [
        isA<ShowDetailsLoaded>().having(
          (s) => s.selectedSeason,
          'selectedSeason',
          3,
        ),
      ],
    );

    blocTest<ShowDetailsBloc, ShowDetailsState>(
      'still loads when a show has no cast and no episodes',
      build: () => ShowDetailsBloc(
        repository: FakeShowDetailsRepository(cast: [], episodes: []),
      ),
      act: (bloc) => bloc.add(const LoadShowDetails(169)),
      expect: () => [
        const ShowDetailsLoading(),
        const ShowDetailsLoaded(
          show: breakingBad,
          cast: [],
          episodes: [],
          selectedSeason: 1,
        ),
      ],
    );

    blocTest<ShowDetailsBloc, ShowDetailsState>(
      'emits Error when the show request fails',
      build: () => ShowDetailsBloc(repository: FakeShowDetailsRepository()),
      act: (bloc) => bloc.add(const LoadShowDetails(404)),
      expect: () => [
        const ShowDetailsLoading(),
        const ShowDetailsError('Server error (404). Please try again.'),
      ],
    );

    blocTest<ShowDetailsBloc, ShowDetailsState>(
      'emits Error when ANY of the 3 requests fails (Future.wait)',
      build: () => ShowDetailsBloc(
        repository: FakeShowDetailsRepository(failCast: true),
      ),
      act: (bloc) => bloc.add(const LoadShowDetails(169)),
      expect: () => [
        const ShowDetailsLoading(),
        const ShowDetailsError('Could not load cast.'),
      ],
    );
  });

  group('SeasonSelected', () {
    blocTest<ShowDetailsBloc, ShowDetailsState>(
      'changes only the selected season',
      build: () => ShowDetailsBloc(repository: FakeShowDetailsRepository()),
      seed: () => loaded,
      act: (bloc) => bloc.add(const SeasonSelected(2)),
      expect: () => [loaded.copyWith(selectedSeason: 2)],
    );

    blocTest<ShowDetailsBloc, ShowDetailsState>(
      'is ignored while the page is still loading',
      build: () => ShowDetailsBloc(repository: FakeShowDetailsRepository()),
      act: (bloc) => bloc.add(const SeasonSelected(2)),
      expect: () => <ShowDetailsState>[],
    );
  });

  group('ShowDetailsLoaded helpers (episodes grouped by season)', () {
    test('seasons returns each season once, sorted', () {
      const state = ShowDetailsLoaded(
        show: breakingBad,
        cast: [],
        episodes: [
          Episode(id: 1, name: 'a', season: 2),
          Episode(id: 2, name: 'b', season: 1),
          Episode(id: 3, name: 'c', season: 2),
        ],
        selectedSeason: 1,
      );
      expect(state.seasons, [1, 2]);
    });

    test('episodesOfSeason returns only that season', () {
      expect(loaded.episodesOfSeason(1).map((e) => e.name), [
        'Pilot',
        "Cat's in the Bag...",
      ]);
      expect(loaded.episodesOfSeason(2).single.name, 'Seven Thirty-Seven');
      expect(loaded.episodesOfSeason(9), isEmpty);
    });
  });
}
