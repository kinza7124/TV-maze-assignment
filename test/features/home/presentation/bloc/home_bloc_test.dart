import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_application_1/core/network/api_exception.dart';
import 'package:flutter_application_1/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_application_1/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/test_data.dart';

/// blocTest reads like a sentence:
///   build  -> create the BLoC
///   seed   -> (optional) the state to start from
///   act    -> add events
///   expect -> the states the BLoC must emit, in order
void main() {
  late FakeHomeRepository repository;

  setUp(() {
    repository = FakeHomeRepository(
      pages: {
        0: [breakingBad, dark],
        1: [firefly],
      },
    );
  });

  test('initial state is HomeInitial', () {
    expect(HomeBloc(repository: repository).state, const HomeInitial());
  });

  group('FetchShows', () {
    blocTest<HomeBloc, HomeState>(
      'emits [Loading, Loaded] with page 0',
      build: () => HomeBloc(repository: repository),
      act: (bloc) => bloc.add(const FetchShows()),
      expect: () => [
        const HomeLoading(),
        const HomeLoaded(shows: [breakingBad, dark], currentPage: 0),
      ],
      verify: (_) => expect(repository.requestedPages, [0]),
    );

    blocTest<HomeBloc, HomeState>(
      'emits Loaded with hasReachedEnd when the API has no shows (empty)',
      build: () => HomeBloc(repository: FakeHomeRepository()),
      act: (bloc) => bloc.add(const FetchShows()),
      expect: () => [
        const HomeLoading(),
        const HomeLoaded(shows: [], currentPage: 0, hasReachedEnd: true),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [Loading, Error] with the API message when it fails',
      build: () {
        repository.error = const ApiException('No internet connection.');
        return HomeBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const FetchShows()),
      expect: () => [
        const HomeLoading(),
        const HomeError('No internet connection.'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits a general message for an unexpected error',
      build: () {
        repository.error = Exception('boom');
        return HomeBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const FetchShows()),
      expect: () => [
        const HomeLoading(),
        const HomeError('Something went wrong. Please try again.'),
      ],
    );
  });

  group('FetchMoreShows (pagination)', () {
    const loadedPage0 = HomeLoaded(shows: [breakingBad, dark], currentPage: 0);

    blocTest<HomeBloc, HomeState>(
      'loads page 1 and adds it to the end of the list',
      build: () => HomeBloc(repository: repository),
      seed: () => loadedPage0,
      act: (bloc) => bloc.add(const FetchMoreShows()),
      expect: () => [
        loadedPage0.copyWith(isLoadingMore: true),
        const HomeLoaded(shows: [breakingBad, dark, firefly], currentPage: 1),
      ],
      verify: (_) => expect(repository.requestedPages, [1]),
    );

    blocTest<HomeBloc, HomeState>(
      'sets hasReachedEnd when the next page is empty',
      build: () => HomeBloc(repository: repository),
      seed: () => const HomeLoaded(shows: [firefly], currentPage: 1),
      act: (bloc) => bloc.add(const FetchMoreShows()),
      expect: () => [
        const HomeLoaded(shows: [firefly], currentPage: 1, isLoadingMore: true),
        const HomeLoaded(shows: [firefly], currentPage: 2, hasReachedEnd: true),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'keeps the old shows and sets loadMoreFailed when it fails',
      build: () {
        repository.error = const ApiException('No internet connection.');
        return HomeBloc(repository: repository);
      },
      seed: () => loadedPage0,
      act: (bloc) => bloc.add(const FetchMoreShows()),
      expect: () => [
        loadedPage0.copyWith(isLoadingMore: true),
        loadedPage0.copyWith(loadMoreFailed: true),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'does nothing when all pages are already loaded',
      build: () => HomeBloc(repository: repository),
      seed: () => loadedPage0.copyWith(hasReachedEnd: true),
      act: (bloc) => bloc.add(const FetchMoreShows()),
      expect: () => <HomeState>[],
      verify: (_) => expect(repository.requestedPages, isEmpty),
    );

    blocTest<HomeBloc, HomeState>(
      'does nothing while a page is already loading (no duplicate calls)',
      build: () => HomeBloc(repository: repository),
      seed: () => loadedPage0.copyWith(isLoadingMore: true),
      act: (bloc) => bloc.add(const FetchMoreShows()),
      expect: () => <HomeState>[],
      verify: (_) => expect(repository.requestedPages, isEmpty),
    );

    blocTest<HomeBloc, HomeState>(
      'does nothing before the first page is loaded',
      build: () => HomeBloc(repository: repository),
      act: (bloc) => bloc.add(const FetchMoreShows()),
      expect: () => <HomeState>[],
    );
  });
}
