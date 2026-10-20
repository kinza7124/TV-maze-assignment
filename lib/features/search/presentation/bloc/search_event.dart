import 'package:equatable/equatable.dart';

/// Which tab is selected in the Search screen.
enum SearchCategory { shows, people }

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Fired every time the user types in the search field.
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Fired when the user taps "Shows" or "People".
class SearchCategoryChanged extends SearchEvent {
  final SearchCategory category;

  const SearchCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}
