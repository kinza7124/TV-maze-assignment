import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC: receives events, gets data from the repository, emits states.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(const HomeInitial()) {
    on<FetchShows>(_onFetchShows);
    on<FetchMoreShows>(_onFetchMoreShows);
  }

  /// Loads page 0.
  Future<void> _onFetchShows(FetchShows event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      final shows = await repository.getShows(0);
      emit(
        HomeLoaded(shows: shows, currentPage: 0, hasReachedEnd: shows.isEmpty),
      );
    } catch (error) {
      emit(HomeError(ApiException.messageFrom(error)));
    }
  }

  /// Pagination: loads the next page and adds it to the old list.
  Future<void> _onFetchMoreShows(
    FetchMoreShows event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;

    // Do nothing if: not loaded yet, already loading, or no more pages.
    if (currentState is! HomeLoaded ||
        currentState.isLoadingMore ||
        currentState.hasReachedEnd) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true, loadMoreFailed: false));

    try {
      final nextPage = currentState.currentPage + 1;
      final newShows = await repository.getShows(nextPage);
      emit(
        currentState.copyWith(
          shows: [...currentState.shows, ...newShows],
          currentPage: nextPage,
          hasReachedEnd: newShows.isEmpty,
          isLoadingMore: false,
          loadMoreFailed: false,
        ),
      );
    } catch (_) {
      // Keep the old shows on screen, just show a retry button at the bottom.
      emit(currentState.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }
}
