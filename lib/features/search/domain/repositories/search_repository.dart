import '../../../../core/entities/show.dart';
import '../entities/person.dart';

/// REPOSITORY CONTRACT for searching shows and people.
abstract class SearchRepository {
  Future<List<Show>> searchShows(String query);
  Future<List<Person>> searchPeople(String query);
}
