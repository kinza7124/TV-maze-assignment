import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_application_1/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_application_1/features/search/presentation/bloc/search_event.dart';
import 'package:flutter_application_1/features/search/presentation/bloc/search_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/test_data.dart';

/// The search is debounced by 500 ms, so every test waits a bit longer.
const debounceWait = Duration(milliseconds: 600);

void main() {
  late FakeSearchRepository repository;

  setUp(() => repository = FakeSearchRepository());

  test('initial state is SearchInitial', () {
    expect(SearchBloc(repository: repository).state, const SearchInitial());
  });

  group('SearchQueryChanged', () {
    blocTest<SearchBloc, SearchState>(
      'emits [Loading, Loaded] when shows are found',
      build: () => SearchBloc(repository: repository),
      act: (bloc) => bloc.add(const SearchQueryChanged('dark')),
      wait: debounceWait,
      expect: () => [
        const SearchLoading(),
        const SearchLoaded([dark]),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [Loading, Empty] when nothing is found',
      build: () => SearchBloc(repository: repository),
      act: (bloc) => bloc.add(const SearchQueryChanged('zzzz')),
      wait: debounceWait,
      expect: () => [const SearchLoading(), const SearchEmpty('zzzz')],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [Loading, Error] with the message and query when the API fails',
      build: () => SearchBloc(repository: repository),
      act: (bloc) => bloc.add(const SearchQueryChanged('error')),
      wait: debounceWait,
      expect: () => [
        const SearchLoading(),
        const SearchError(message: 'No internet connection.', query: 'error'),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'shows a general message for an unexpected error',
      build: () => SearchBloc(repository: repository),
      act: (bloc) => bloc.add(const SearchQueryChanged('crash')),
      wait: debounceWait,
      expect: () => [
        const SearchLoading(),
        const SearchError(
          message: 'Something went wrong. Please try again.',
          query: 'crash',
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'trims spaces before searching',
      build: () => SearchBloc(repository: repository),
      act: (bloc) => bloc.add(const SearchQueryChanged('  dark  ')),
      wait: debounceWait,
      expect: () => [
        const SearchLoading(),
        const SearchLoaded([dark]),
      ],
      verify: (_) => expect(repository.showQueries, ['dark']),
    );

    blocTest<SearchBloc, SearchState>(
      'goes back to Initial when the text is cleared (no API call)',
      build: () => SearchBloc(repository: repository),
      seed: () => const SearchLoaded([dark]),
      act: (bloc) => bloc.add(const SearchQueryChanged('')),
      wait: debounceWait,
      expect: () => [const SearchInitial()],
      verify: (_) => expect(repository.showQueries, isEmpty),
    );
  });

  group('debounce', () {
    blocTest<SearchBloc, SearchState>(
      'fast typing calls the API only once, with the last text',
      build: () => SearchBloc(repository: repository),
      act: (bloc) {
        bloc
          ..add(const SearchQueryChanged('d'))
          ..add(const SearchQueryChanged('da'))
          ..add(const SearchQueryChanged('dar'))
          ..add(const SearchQueryChanged('dark'));
      },
      wait: debounceWait,
      expect: () => [
        const SearchLoading(),
        const SearchLoaded([dark]),
      ],
      verify: (_) => expect(repository.showQueries, ['dark']),
    );

    test('does not search before 500 ms have passed', () async {
      final bloc = SearchBloc(repository: repository);

      bloc.add(const SearchQueryChanged('dark'));
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(repository.showQueries, isEmpty); // still waiting
      expect(bloc.state, const SearchInitial());

      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(repository.showQueries, ['dark']); // now it searched

      await bloc.close();
    });
  });

  group('SearchCategoryChanged', () {
    blocTest<SearchBloc, SearchState>(
      'switching to People searches people with the same text',
      build: () => SearchBloc(repository: repository),
      act: (bloc) async {
        bloc.add(const SearchQueryChanged('bryan'));
        await Future<void>.delayed(debounceWait);
        bloc.add(const SearchCategoryChanged(SearchCategory.people));
      },
      expect: () => [
        const SearchLoading(),
        const SearchEmpty('bryan'), // no SHOW called "bryan"
        const SearchLoading(),
        const PeopleLoaded([bryan]), // but a PERSON is found
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'switching tabs with an empty search field stays Initial',
      build: () => SearchBloc(repository: repository),
      act: (bloc) =>
          bloc.add(const SearchCategoryChanged(SearchCategory.people)),
      expect: () => [const SearchInitial()],
    );
  });
}
