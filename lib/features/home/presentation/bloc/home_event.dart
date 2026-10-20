import 'package:equatable/equatable.dart';

/// EVENTS = things that happen (user actions) that the BLoC reacts to.
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load the first page of shows (also used for pull-to-refresh / retry).
class FetchShows extends HomeEvent {
  const FetchShows();
}

/// User scrolled to the bottom -> load the next page.
class FetchMoreShows extends HomeEvent {
  const FetchMoreShows();
}
