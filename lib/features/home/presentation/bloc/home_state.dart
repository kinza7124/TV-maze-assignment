import 'package:equatable/equatable.dart';

import '../../../../core/entities/show.dart';

/// STATES = what the UI should show right now.
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Nothing loaded yet.
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// First page is loading -> show a spinner.
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Shows loaded successfully.
class HomeLoaded extends HomeState {
  final List<Show> shows;
  final int currentPage;
  final bool hasReachedEnd; // true when the API has no more pages
  final bool isLoadingMore; // true while the next page is loading
  final bool loadMoreFailed; // true if loading the next page failed

  const HomeLoaded({
    required this.shows,
    required this.currentPage,
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  /// Makes a copy with some values changed (states are immutable).
  HomeLoaded copyWith({
    List<Show>? shows,
    int? currentPage,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) {
    return HomeLoaded(
      shows: shows ?? this.shows,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }

  @override
  List<Object?> get props => [
    shows,
    currentPage,
    hasReachedEnd,
    isLoadingMore,
    loadMoreFailed,
  ];
}

/// First page failed to load.
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
