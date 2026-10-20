import 'package:equatable/equatable.dart';

import '../../../../core/entities/show.dart';
import '../../domain/entities/person.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Search field is empty.
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Waiting for the API.
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Shows found (Shows tab).
class SearchLoaded extends SearchState {
  final List<Show> shows;

  const SearchLoaded(this.shows);

  @override
  List<Object?> get props => [shows];
}

/// People found (People tab).
class PeopleLoaded extends SearchState {
  final List<Person> people;

  const PeopleLoaded(this.people);

  @override
  List<Object?> get props => [people];
}

/// API worked but returned nothing.
class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

/// API call failed.
class SearchError extends SearchState {
  final String message;
  final String query; // kept so the "Try Again" button can search again

  const SearchError({required this.message, required this.query});

  @override
  List<Object?> get props => [message, query];
}
