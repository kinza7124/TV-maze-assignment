import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/repositories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

/// DEBOUNCE: wait until the user stops typing for [duration]
/// before handling the event. switchMap cancels the old search
/// if a new one starts, so we never show outdated results.
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  // Remember the last query and tab, so either event can run the search.
  String _query = '';
  SearchCategory _category = SearchCategory.shows;

  SearchBloc({required this.repository}) : super(const SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<SearchCategoryChanged>(_onCategoryChanged);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    _query = event.query.trim();
    await _search(emit);
  }

  Future<void> _onCategoryChanged(
    SearchCategoryChanged event,
    Emitter<SearchState> emit,
  ) async {
    _category = event.category;
    await _search(emit);
  }

  Future<void> _search(Emitter<SearchState> emit) async {
    final query = _query;

    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());
    try {
      if (_category == SearchCategory.shows) {
        final shows = await repository.searchShows(query);
        emit(shows.isEmpty ? SearchEmpty(query) : SearchLoaded(shows));
      } else {
        final people = await repository.searchPeople(query);
        emit(people.isEmpty ? SearchEmpty(query) : PeopleLoaded(people));
      }
    } catch (error) {
      emit(SearchError(message: ApiException.messageFrom(error), query: query));
    }
  }
}
